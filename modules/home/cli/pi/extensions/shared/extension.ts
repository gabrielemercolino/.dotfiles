import { Type } from "typebox";
import { Text } from "@earendil-works/pi-tui";
import type {
  ExtensionAPI,
  Theme,
  ToolRenderContext,
  ToolRenderResultOptions,
} from "@earendil-works/pi-coding-agent";
import type { SubAgentResult } from "./subagent.ts";

export interface SubAgentExtensionConfig {
  name: string;
  label: string;
  description: string;
  promptSnippet: string;
  promptGuidelines: string[];
  taskDescription: string;
  run: (
    task: string,
    signal: AbortSignal | undefined,
    onStatus: (status: string) => void,
  ) => Promise<SubAgentResult>;
  formatSummary: (
    toolCalls: Array<{ toolName: string; args: Record<string, unknown> }>,
    output?: string,
  ) => string;
}

export function createSubAgentExtension(config: SubAgentExtensionConfig) {
  return function (pi: ExtensionAPI) {
    pi.registerTool({
      name: config.name,
      label: config.label,
      description: config.description,
      promptSnippet: config.promptSnippet,
      promptGuidelines: config.promptGuidelines,
      parameters: Type.Object({
        task: Type.String({ description: config.taskDescription }),
      }),
      async execute(toolCallId, params, signal, onUpdate, _ctx) {
        const task = params.task;

        if (signal?.aborted) {
          return {
            content: [
              {
                type: "text",
                text: `${config.label} was cancelled before it could start.`,
              },
            ],
            details: { cancelled: true },
            isError: true,
          };
        }

        const result = await config.run(task, signal, (status) => {
          onUpdate?.({
            content: [{ type: "text", text: status }],
            details: { status, isPartial: true },
          });
        });

        if (result.error) {
          return {
            content: [{ type: "text", text: result.error }],
            details: { error: result.error },
            usage: result.usage,
            isError: true,
          };
        }

        const finalSummary = config.formatSummary(result.toolCalls, result.output);

        return {
          content: [{ type: "text", text: finalSummary }],
          details: {
            status: finalSummary,
            toolCalls: result.toolCalls,
            exitCode: result.exitCode,
            exitSignal: result.exitSignal,
          },
          usage: result.usage,
        };
      },

      renderCall(
        _args: { task: string },
        theme: Theme,
        _context: ToolRenderContext,
      ) {
        return new Text(theme.fg("toolTitle", theme.bold(config.name)), 0, 0);
      },

      renderResult(
        result: {
          content: Array<{ type: string; text: string }>;
          details?: Record<string, unknown>;
        },
        options: ToolRenderResultOptions,
        theme: Theme,
        _context: ToolRenderContext,
      ) {
        if (options.isPartial) {
          const status = String(
            (result.details as Record<string, unknown>)?.status ?? "",
          );
          return new Text(theme.fg("muted", status), 0, 0);
        }
        const text = result.content?.[0]?.text ?? "";
        return new Text(text, 0, 0);
      },
    });

    pi.on("session_start", () => {
      const current = pi.getActiveTools();
      pi.setActiveTools([...new Set([...current, config.name])]);
    });
  };
}

export interface SummaryDescriptor {
  displayName: string;
  label?: (args: Record<string, unknown>) => string;
}

export type SummaryDescriptors = Record<string, SummaryDescriptor>;

function capitalize(s: string): string {
  return s.charAt(0).toUpperCase() + s.slice(1);
}

export function buildFormatSummary(descriptors: SummaryDescriptors) {
  return function formatSummary(
    toolCalls: Array<{ toolName: string; args: Record<string, unknown> }>,
    output = "",
  ): string {
    const groups = new Map<string, string[]>();

    for (const call of toolCalls) {
      const desc = descriptors[call.toolName];
      const label = desc?.label?.(call.args) ?? call.toolName;
      const group = groups.get(call.toolName) ?? [];
      group.push(label);
      groups.set(call.toolName, group);
    }

    const lines: string[] = [];
    for (const [toolName, items] of groups) {
      const displayName = descriptors[toolName]?.displayName ?? capitalize(toolName);
      lines.push(`${displayName} ${items.join(", ")}`);
    }

    const parts: string[] = [];
    const trimmedOutput = output.trim();
    if (trimmedOutput) {
      parts.push(trimmedOutput);
    }

    const toolSummary = lines.join("\n");
    if (toolSummary) {
      parts.push(toolSummary);
    }

    return parts.join("\n\n");
  };
}
