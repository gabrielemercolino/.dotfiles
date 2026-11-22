# Session cost in dollars

Adds a dollar amount to the DeepSeek Harness terminal footer, next to the
built-in model and token cells: `$0.0042`. The number is this session's spend,
subagents included, priced with DeepSeek's official **USD** list instead of the
`¥` estimate the terminal ships with.

## Where the number comes from

DeepSeek's API returns token counts, not money, so every figure here is an
estimate. The plugin reads the session's own event stream:

- `request/header` and `request/context` say which provider and model a request
  went to, which decides whether a DeepSeek price list applies at all;
- `assistant/message` is the only event carrying `usage`; messages without one
  are skipped rather than counted as zero.

Each usage event is priced at the rate of the hour it happened in, using
DeepSeek's published USD rates per million tokens:

| | cache hit | cache miss | output |
|---|---|---|---|
| `deepseek-flash` off-peak | $0.003 | $0.15 | $0.6 |
| `deepseek-flash` peak | $0.006 | $0.3 | $1.2 |
| `deepseek-v4-pro` off-peak | $0.022 | $0.66 | $1.98 |
| `deepseek-v4-pro` peak | $0.044 | $1.32 | $3.96 |

Peak hours are 01:00–04:00 and 06:00–10:00 UTC, Monday to Friday; everything
else is off-peak at half price. Cache writes are billed at the cache-miss rate,
as DeepSeek does. The retired `deepseek-v4-flash*` ids resolve to the Flash
price because DeepSeek still bills them there.

## Usage

Nothing to run. The field appears once the session has billable usage, hovers
to a breakdown (`main`, `subagents`, tokens, peak and off-peak shares), and
disappears when the session has none.

Because it occupies the footer rather than replacing it, the built-in `≈¥` chip
stays unless you turn it off: `/settings` → status bar → *Show session cost
estimate*.

## Configuration

Every key is optional; the row's `config` in the bundle patch overrides them.

| key | default | meaning |
|---|---|---|
| `enabled` | `true` | total switch |
| `providers` | `deepseek`, `deepseek-official`, `deepseek-vision` | routes priced as DeepSeek |
| `prices` | built in | `{ "<model prefix>": { hit: [off, peak], miss: [off, peak], out: [off, peak] } }`, merged over the defaults |
| `status.enabled` | `true` | show the field |
| `status.slot` | `left-tail` | `left-tail`, `right-head`, `right-tail` |
| `status.tone` | `dim` | `dim`, `accent`, `success`, `warning`, `error` |
| `status.maxCells` | `20` | text cap in terminal cells, 1–32 |
| `status.minColumns` | `0` | hide the field on terminals narrower than this |
| `status.showWindow` | `false` | append `peak` / `off-peak` to the cell |

## Limits

- Chinese public holidays are off-peak for DeepSeek but not modeled here, so a
  holiday-hour estimate can be high by the peak/off-peak difference.
- Only routes in `providers` are priced; a model with no matching prefix in
  `prices` contributes tokens but no money, and is left out of the total rather
  than guessed.
- Prices change. They are constants in `lib/index.js` and this document, not
  fetched at runtime.
- The session is the last one that produced usage in this terminal; a `/new`
  session starts a fresh total.
