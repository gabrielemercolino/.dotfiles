import { Type } from "typebox";
import { Text } from "@earendil-works/pi-tui";
import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import type { ToolRenderContext, ToolRenderResultOptions } from "@earendil-works/pi-coding-agent";
import { runBasher } from "./runner.ts";
import { formatSummary } from "./format.ts";
import type { BasherResult } from "./runner.ts";

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "basher",
		label: "Basher",
		description:
			"Delegate CLI operations to the basher. " +
			"Use when you need to inspect directories, run chains of shell commands, or perform file operations. " +
			"The basher will verify safety before executing. " +
			"Provide a clear description of what you need done.",
		promptSnippet: "Delegate CLI operations",
		promptGuidelines: [
			"Use basher when you need to perform CLI operations — inspecting directories, removing files, " +
			"running chains of shell commands. Describe the task in natural language; the basher will inspect, " +
			"verify safety, and execute.",
			"If the basher refuses, read its explanation carefully. You may need to clarify " +
		  "the task or ask the user for more information.",
		],
		parameters: Type.Object({
			task: Type.String({
				description: "Detailed instructions for the basher",
			}),
		}),
		async execute(toolCallId, params, signal, onUpdate, _ctx) {
			const task = params.task;

			if (signal?.aborted) {
				return {
					content: [
						{
							type: "text",
							text: "Basher was cancelled before it could start.",
						},
					],
					details: { cancelled: true },
					isError: true,
				};
			}

			const result: BasherResult = await runBasher(
				task,
				signal,
				(status) => {
					onUpdate?.({
						content: [{ type: "text", text: status }],
						details: { status, isPartial: true },
					});
				},
			);

			if (result.error) {
				return {
					content: [{ type: "text", text: result.error }],
					details: { error: result.error },
					usage: result.usage,
					isError: true,
				};
			}

			const finalSummary = formatSummary(result.toolCalls, result.output);

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
			return new Text(theme.fg("toolTitle", theme.bold("basher")), 0, 0);
		},

		renderResult(
			result: { content: Array<{ type: string; text: string }>; details?: Record<string, unknown> },
			options: ToolRenderResultOptions,
			theme: Theme,
			_context: ToolRenderContext,
		) {
			if (options.isPartial) {
				const status = String((result.details as Record<string, unknown>)?.status ?? "");
				return new Text(theme.fg("muted", status), 0, 0);
			}
			const text = result.content?.[0]?.text ?? "";
			return new Text(text, 0, 0);
		},
	});

	pi.on("session_start", () => {
		const current = pi.getActiveTools();
		pi.setActiveTools([...new Set([...current, "basher"])]);
	});
}
