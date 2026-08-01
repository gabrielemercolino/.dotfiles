import { Type } from "typebox";
import { Text } from "@earendil-works/pi-tui";
import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import type { ToolRenderContext, ToolRenderResultOptions } from "@earendil-works/pi-coding-agent";
import { runCoder } from "./runner.ts";
import { formatSummary } from "./format.ts";
import type { CoderResult } from "./runner.ts";

export default function (pi: ExtensionAPI) {
	// Guard: don't register the coder tool if we're already inside a coder sub-agent
	if (process.env.PI_CODER_DISABLED) {
		console.error(
			"[coder] extension loaded but PI_CODER_DISABLED is set — skipping tool registration",
		);
		return;
	}

	pi.registerTool({
		name: "coder",
		label: "Coder",
		description:
			"Delegate code implementation to the coder. " +
			"Use when the user agrees on a plan and wants code written. " +
			"Provide clear, specific instructions.",
		parameters: Type.Object({
			task: Type.String({
				description: "Detailed implementation instructions for the coder",
			}),
		}),
		async execute(toolCallId, params, signal, onUpdate, _ctx) {
			const task = params.task;

			if (signal?.aborted) {
				return {
					content: [
						{
							type: "text",
							text: "Coder was cancelled before it could start.",
						},
					],
					details: { cancelled: true },
					isError: true,
				};
			}

			const result: CoderResult = await runCoder(
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
			return new Text(theme.fg("toolTitle", theme.bold("coder")), 0, 0);
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
		pi.setActiveTools(["read", "grep", "find", "ls", "coder"]);
	});
}
