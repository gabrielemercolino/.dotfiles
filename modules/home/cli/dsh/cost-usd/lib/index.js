/**
 * cost-usd — the session cost in the dsh-tui footer, in US dollars.
 *
 * Why: dsh-tui's built-in chip prices a session with DeepSeek's CNY list and
 * prints a hardcoded `¥`. This plugin reads the same durable usage events,
 * prices them with DeepSeek's official USD list (peak / off-peak), and adds a
 * `$` cell to the footer through `ctx.tuiStatus.setField` — the documented
 * plugin seam — without patching the host package.
 *
 * Shape of the data, from the session event stream:
 *  - `request/header` / `request/context` carry the provider and model a
 *    request is routed to, i.e. which price list applies;
 *  - `assistant/message` is the only event carrying `usage`; a message without
 *    one is skipped rather than counted as zero.
 *
 * Zero runtime dependencies, no network, read-only: the plugin never writes to
 * the session, so installing it cannot make a session unresumable.
 */

const PER_MILLION = 1_000_000

/** USD per 1M tokens, indexed [off-peak, peak] — DeepSeek's English pricing
 *  page (2026-11). Off-peak is half the peak rate. */
const FLASH = Object.freeze({
  hit: [0.003, 0.006],
  miss: [0.15, 0.3],
  out: [0.6, 1.2],
})
const PRO = Object.freeze({
  hit: [0.022, 0.044],
  miss: [0.66, 1.32],
  out: [1.98, 3.96],
})

/** Longest-prefix match on the model id, as the host does. The retired
 *  `deepseek-v4-flash*` ids are still served by V4.1-Flash and billed at the
 *  Flash price. */
const DEFAULT_PRICES = Object.freeze({
  'deepseek-flash': FLASH,
  'deepseek-v4-flash': FLASH,
  'deepseek-v4-flash-vision-exp': FLASH,
  'deepseek-v4-pro': PRO,
})

/** Routes priced by DeepSeek itself. Any other provider keeps its tokens out
 *  of the dollars, even when the model id looks familiar. */
const DEFAULT_PROVIDERS = Object.freeze(['deepseek', 'deepseek-official', 'deepseek-vision'])

const FIELD_KEY = 'cost-usd'
const SLOTS = ['left-tail', 'right-head', 'right-tail']
const TONES = ['dim', 'accent', 'success', 'warning', 'error']
const ZERO = Object.freeze({ input: 0, output: 0, cacheRead: 0, cacheWrite: 0 })

export const name = 'cost-usd'

function isRecord(value) {
  return value !== null && typeof value === 'object' && !Array.isArray(value)
}

function clampInt(value, fallback, min, max) {
  if (typeof value !== 'number' || !Number.isFinite(value)) return fallback
  return Math.min(max, Math.max(min, Math.round(value)))
}

function normalizePrice(value) {
  if (!isRecord(value)) return undefined
  const pairs = (field) => {
    const raw = value[field]
    if (!Array.isArray(raw) || raw.length !== 2) return undefined
    const [off, peak] = raw
    if (![off, peak].every((n) => typeof n === 'number' && Number.isFinite(n) && n >= 0)) return undefined
    return [off, peak]
  }
  const hit = pairs('hit')
  const miss = pairs('miss')
  const out = pairs('out')
  return hit === undefined || miss === undefined || out === undefined ? undefined : { hit, miss, out }
}

function mergePrices(overrides) {
  const prices = { ...DEFAULT_PRICES }
  for (const [model, value] of Object.entries(overrides)) {
    const price = normalizePrice(value)
    if (price !== undefined) prices[model] = price
  }
  return prices
}

function resolveConfig(raw) {
  const input = isRecord(raw) ? raw : {}
  const status = isRecord(input.status) ? input.status : {}
  return {
    enabled: input.enabled !== false,
    providers: Array.isArray(input.providers)
      ? input.providers.filter((provider) => typeof provider === 'string' && provider !== '')
      : [...DEFAULT_PROVIDERS],
    prices: mergePrices(isRecord(input.prices) ? input.prices : {}),
    status: {
      enabled: status.enabled !== false,
      slot: SLOTS.includes(status.slot) ? status.slot : 'left-tail',
      tone: TONES.includes(status.tone) ? status.tone : 'dim',
      maxCells: clampInt(status.maxCells, 20, 1, 32),
      minColumns: clampInt(status.minColumns, 0, 0, 400),
      showWindow: status.showWindow === true,
    },
  }
}

function priceFor(model, prices) {
  let best
  for (const [prefix, price] of Object.entries(prices)) {
    if (!model.startsWith(prefix)) continue
    if (best === undefined || prefix.length > best.length) best = { length: prefix.length, price }
  }
  return best?.price
}

/** Peak is 01:00-04:00 and 06:00-10:00 UTC, Monday to Friday; every other hour,
 *  including weekends, is off-peak. Chinese public holidays are off-peak too
 *  but are not in this table — they under-state, never over-state, the price. */
function isPeak(ms) {
  const date = new Date(ms)
  const day = date.getUTCDay()
  if (day === 0 || day === 6) return false
  const hour = date.getUTCHours()
  return (hour >= 1 && hour < 4) || (hour >= 6 && hour < 10)
}

function eventTimeOf(event) {
  const time = isRecord(event) ? event['time'] : undefined
  return typeof time === 'number' && Number.isFinite(time) ? time : undefined
}

function nonEmptyString(value) {
  return typeof value === 'string' && value.trim() !== '' ? value : undefined
}

function routeOf(event) {
  if (!isRecord(event)) return undefined
  const type = event['type']
  if (type !== 'request/header' && type !== 'request/context') return undefined
  const data = event['data']
  if (!isRecord(data)) return undefined
  if (type === 'request/header') {
    const header = data['header']
    const config = isRecord(header) ? header['config'] : undefined
    if (!isRecord(config)) return undefined
    const provider = nonEmptyString(config['provider'])
    const model = nonEmptyString(config['model'])
    return provider === undefined || model === undefined ? undefined : { provider, model }
  }
  const provider = nonEmptyString(data['provider'])
  const model = nonEmptyString(data['model'])
  return provider === undefined || model === undefined ? undefined : { provider, model }
}

function usageOf(event) {
  if (!isRecord(event) || event['type'] !== 'assistant/message') return undefined
  const data = event['data']
  const usage = isRecord(data) ? data['usage'] : undefined
  if (!isRecord(usage)) return undefined
  const count = (key) => {
    const value = usage[key]
    return typeof value === 'number' && Number.isFinite(value) && value > 0 ? value : 0
  }
  const counts = {
    input: count('inputTokens'),
    output: count('outputTokens'),
    cacheRead: count('cacheReadTokens'),
    cacheWrite: count('cacheWriteTokens'),
  }
  const total = counts.input + counts.output + counts.cacheRead + counts.cacheWrite
  return total > 0 ? counts : undefined
}

function formatTokens(value) {
  if (!Number.isFinite(value) || value <= 0) return '0'
  if (value >= PER_MILLION) return `${(value / PER_MILLION).toFixed(1)}M`
  if (value >= 1000) return `${(value / 1000).toFixed(1)}k`
  return String(Math.round(value))
}

/** Cents are too coarse for one session: four places below a dollar, matching
 *  the host's own reported-cost formatter. */
function formatUsd(value) {
  if (!(value > 0)) return '$0.0000'
  if (value < 0.0001) return '<$0.0001'
  return `$${value.toFixed(value < 1 ? 4 : 2)}`
}

export function apply(ctx, rawConfig = {}) {
  const config = resolveConfig(rawConfig)
  if (!config.enabled) return

  /** sessionId -> { id, parentId, subagent, route, peak, off, lastSeen } */
  const sessions = new Map()
  let publishStatus = () => {}

  const stateOf = (session) => {
    const id = nonEmptyString(session?.['id']) ?? 'anonymous'
    let state = sessions.get(id)
    if (state === undefined) {
      const header = isRecord(session?.['header']) ? session['header'] : {}
      const depth = header['delegationDepth']
      state = {
        id,
        parentId: nonEmptyString(header['parentSession']) ?? null,
        subagent: header['origin'] === 'subagent' || (typeof depth === 'number' && depth > 0),
        route: undefined,
        peak: { ...ZERO },
        off: { ...ZERO },
        lastSeen: 0,
      }
      sessions.set(id, state)
    }
    return state
  }

  /** Follow `parentSession` up to the session the user opened. An unparented
   *  subagent resolves to `null` and is folded into the active session. */
  const rootOf = (start) => {
    let current = start
    for (let depth = 0; depth < 8 && current !== undefined; depth += 1) {
      if (!current.subagent) return current.id
      if (current.parentId === null) return null
      current = sessions.get(current.parentId)
    }
    return current === undefined ? null : current.id
  }

  const activeRootId = () => {
    let best
    for (const state of sessions.values()) {
      if (state.subagent) continue
      if (best === undefined || state.lastSeen > best.lastSeen) best = state
    }
    return best?.id
  }

  const snapshot = () => {
    const rootId = activeRootId()
    if (rootId === undefined) return undefined
    const totals = { price: { peak: 0, off: 0 }, main: 0, subagent: 0, tokens: ZERO }
    for (const state of sessions.values()) {
      const root = rootOf(state)
      if (root !== rootId && root !== null) continue
      const price = state.route === undefined ? undefined : priceFor(state.route.model, config.prices)
      if (price === undefined) continue
      const timed = (bucket, index) =>
        (bucket.input * price.miss[index]
          + bucket.cacheRead * price.hit[index]
          + bucket.cacheWrite * price.miss[index]
          + bucket.output * price.out[index]) / PER_MILLION
      const peak = timed(state.peak, 1)
      const off = timed(state.off, 0)
      totals.price.peak += peak
      totals.price.off += off
      if (state.id === rootId) totals.main += peak + off
      else totals.subagent += peak + off
      totals.tokens = {
        input: totals.tokens.input + state.peak.input + state.off.input,
        output: totals.tokens.output + state.peak.output + state.off.output,
        cacheRead: totals.tokens.cacheRead + state.peak.cacheRead + state.off.cacheRead,
        cacheWrite: totals.tokens.cacheWrite + state.peak.cacheWrite + state.off.cacheWrite,
      }
    }
    const total = totals.price.peak + totals.price.off
    const tokens = totals.tokens.input + totals.tokens.output + totals.tokens.cacheRead + totals.tokens.cacheWrite
    return total > 0 && tokens > 0 ? { total, ...totals, peakNow: isPeak(Date.now()) } : undefined
  }

  const detailOf = (current) => {
    const parts = [
      formatUsd(current.total),
      `main ${formatUsd(current.main)}`,
      `subagents ${formatUsd(current.subagent)}`,
      `in ${formatTokens(current.tokens.input)}`,
      `out ${formatTokens(current.tokens.output)}`,
      `cache ${formatTokens(current.tokens.cacheRead + current.tokens.cacheWrite)}`,
      `peak ${formatUsd(current.price.peak)}`,
      `off-peak ${formatUsd(current.price.off)}`,
    ]
    const line = parts.join(' · ')
    return line.length <= 158 ? line : `${line.slice(0, 157)}…`
  }

  ctx.on('session/event', (session, event) => {
    const state = stateOf(session)
    const route = routeOf(event)
    if (route !== undefined) {
      state.route = config.providers.includes(route.provider) ? route : undefined
      return
    }
    const usage = usageOf(event)
    if (usage === undefined) return
    if (state.route === undefined) return
    if (priceFor(state.route.model, config.prices) === undefined) return
    const time = eventTimeOf(event) ?? Date.now()
    const peak = isPeak(time)
    const bucket = peak ? state.peak : state.off
    bucket.input += usage.input
    bucket.output += usage.output
    bucket.cacheRead += usage.cacheRead
    bucket.cacheWrite += usage.cacheWrite
    state.lastSeen = time
    publishStatus()
  })

  ctx.on('session/disposed', (session) => {
    const id = nonEmptyString(session?.['id'])
    if (id === undefined) return
    sessions.delete(id)
    publishStatus()
  })

  ctx.inject(['tuiStatus'], (statusCtx) => {
    const status = typeof statusCtx.get === 'function' ? statusCtx.get('tuiStatus', false) : undefined
    if (status === undefined || typeof status.setField !== 'function') return
    if (!config.status.enabled) return

    let handle
    let lastKey = ''
    const publish = () => {
      const current = snapshot()
      const text = current === undefined
        ? undefined
        : `${formatUsd(current.total)}${config.status.showWindow ? (current.peakNow ? ' peak' : ' off-peak') : ''}`
      const detail = current === undefined ? undefined : detailOf(current)
      const options = {
        slot: config.status.slot,
        tone: config.status.tone,
        maxCells: config.status.maxCells,
        minColumns: config.status.minColumns,
        ...(detail === undefined ? {} : { detail }),
      }
      const key = `${text ?? ''}\u0000${JSON.stringify(options)}`
      if (key === lastKey) return
      lastKey = key
      try {
        handle = status.setField(FIELD_KEY, text, options) ?? handle
      } catch {
        // A refused footer cell must never take the TUI down.
      }
    }
    publishStatus = publish
    publish()
    statusCtx.effect(() => () => {
      publishStatus = () => {}
      try {
        handle?.()
      } catch {
        // Cleanup is best effort.
      }
    }, 'cost-usd footer field')
  })
}
