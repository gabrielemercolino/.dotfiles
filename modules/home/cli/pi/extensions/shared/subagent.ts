import {
  createAgentSession,
  createExtensionRuntime,
  ModelRuntime,
  SessionManager,
  type ResourceLoader,
} from "@earendil-works/pi-coding-agent";

export interface SubAgentUsage {
  input: number;
  output: number;
  cacheRead: number;
  cacheWrite: number;
  totalTokens: number;
  cost: {
    input: number;
    output: number;
    cacheRead: number;
    cacheWrite: number;
    total: number;
  };
}

export interface SubAgentResult {
  output: string;
  exitCode: number | null;
  exitSignal: string | null;
  toolCalls: Array<{ toolName: string; args: Record<string, unknown> }>;
  usage: SubAgentUsage;
  error?: string;
}

export interface SubAgentRunnerConfig {
  name: string;
  systemPrompt: string;
  tools: string[];
  customTools?: any[];
  preferredModel?: { provider: string; id: string };
  timeoutMs?: number;
  formatToolCall?: (toolName: string, args: Record<string, unknown>) => string;
}

const DEFAULT_TIMEOUT_MS = 5 * 60 * 1000;

function emptyUsage(): SubAgentUsage {
  return {
    input: 0,
    output: 0,
    cacheRead: 0,
    cacheWrite: 0,
    totalTokens: 0,
    cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, total: 0 },
  };
}

function createResourceLoader(systemPrompt: string): ResourceLoader {
  return {
    getExtensions: () => ({ extensions: [], errors: [], runtime: createExtensionRuntime() }),
    getSkills: () => ({ skills: [], diagnostics: [] }),
    getPrompts: () => ({ prompts: [], diagnostics: [] }),
    getThemes: () => ({ themes: [], diagnostics: [] }),
    getAgentsFiles: () => ({ agentsFiles: [] }),
    getSystemPrompt: () => systemPrompt,
    getSystemPromptSource: () => undefined,
    getAppendSystemPrompt: () => [],
    getAppendSystemPromptSources: () => [],
    extendResources: () => {},
    reload: async () => {},
  };
}

export function createSubAgentRunner(config: SubAgentRunnerConfig) {
  const {
    name,
    systemPrompt,
    tools,
    customTools = [],
    preferredModel = { provider: "deepseek", id: "deepseek-v4-flash" },
    timeoutMs = DEFAULT_TIMEOUT_MS,
    formatToolCall = (toolName) => toolName,
  } = config;

  return async function runSubAgent(
    task: string,
    signal: AbortSignal | undefined,
    onStatus: (status: string) => void,
  ): Promise<SubAgentResult> {
    const toolCalls: Array<{ toolName: string; args: Record<string, unknown> }> = [];
    const usage = emptyUsage();

    let session: { abort(): Promise<void>; dispose(): void } | undefined;
    let timeout: ReturnType<typeof setTimeout> | undefined;
    let onAbort: (() => void) | undefined;

    try {
      const modelRuntime = await ModelRuntime.create();
      const available = await modelRuntime.getAvailable();
      const model =
        available.find(
          (m) => m.provider === preferredModel.provider && m.id === preferredModel.id,
        ) ?? available[0];

      if (!model) {
        return {
          output: "",
          exitCode: 1,
          exitSignal: null,
          toolCalls,
          usage,
          error: `No model available for ${name} sub-agent`,
        };
      }

      const { session: createdSession } = await createAgentSession({
        resourceLoader: createResourceLoader(systemPrompt),
        modelRuntime,
        model,
        tools,
        customTools,
        sessionManager: SessionManager.inMemory(),
        thinkingLevel: "off",
      });
      session = createdSession;

      const abortSession = () => {
        void session?.abort().catch(() => {});
      };
      timeout = setTimeout(abortSession, timeoutMs);
      onAbort = abortSession;
      if (signal) {
        signal.addEventListener("abort", onAbort, { once: true });
      }

      let output = "";

      const done = new Promise<void>((resolve) => {
        session!.subscribe((event) => {
          switch (event.type) {
            case "tool_execution_start": {
              const toolName = event.toolName;
              const args = event.args as Record<string, unknown>;
              onStatus(formatToolCall(toolName, args));
              toolCalls.push({ toolName, args });
              break;
            }
            case "message_update": {
              const updateEvent = event.assistantMessageEvent;
              if (updateEvent?.type === "text_delta" && updateEvent?.delta) {
                output += updateEvent.delta;
              }
              break;
            }
            case "message_end": {
              const msg = event.message;
              if (msg?.usage) {
                usage.input += msg.usage.input || 0;
                usage.output += msg.usage.output || 0;
                usage.cacheRead += msg.usage.cacheRead || 0;
                usage.cacheWrite += msg.usage.cacheWrite || 0;
                usage.totalTokens += msg.usage.totalTokens || 0;
                usage.cost.input += msg.usage.cost?.input || 0;
                usage.cost.output += msg.usage.cost?.output || 0;
                usage.cost.cacheRead += msg.usage.cost?.cacheRead || 0;
                usage.cost.cacheWrite += msg.usage.cost?.cacheWrite || 0;
                usage.cost.total += msg.usage.cost?.total || 0;
              }
              break;
            }
            case "agent_end":
              resolve();
              break;
          }
        });
      });

      await session.prompt(task);
      await done;

      if (timeout) clearTimeout(timeout);
      if (onAbort && signal) signal.removeEventListener("abort", onAbort);
      session.dispose();

      return {
        output: output.trim() || `${name} finished with no output.`,
        exitCode: 0,
        exitSignal: null,
        toolCalls,
        usage,
      };
    } catch (err: any) {
      if (timeout) clearTimeout(timeout);
      if (onAbort && signal) signal.removeEventListener("abort", onAbort);

      if (
        err?.name === "AbortError" ||
        err?.name === "TimeoutError" ||
        signal?.aborted
      ) {
        void session?.abort().catch(() => {});
        return {
          output: "",
          exitCode: null,
          exitSignal: "SIGTERM",
          toolCalls,
          usage,
          error: `${name} timed out or was cancelled`,
        };
      }

      session?.dispose();
      return {
        output: "",
        exitCode: 1,
        exitSignal: null,
        toolCalls,
        usage,
        error: err?.message ?? String(err),
      };
    }
  };
}
