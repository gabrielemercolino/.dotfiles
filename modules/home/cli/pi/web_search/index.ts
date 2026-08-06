import { Type } from "typebox";
import { Text } from "@earendil-works/pi-tui";
import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import type { ToolRenderContext, ToolRenderResultOptions } from "@earendil-works/pi-coding-agent";
import { runWebSearch } from "./runner.ts";
import { formatSummary } from "./format.ts";
import type { WebSearchResult } from "./runner.ts";

export default function (pi: ExtensionAPI) {
	pi.registerTool({
		name: "web_search",
		label: "WebSearch",
		description:
			"Search the web for information. Use when you need to look up current information, documentation, news, " +
			"or anything that requires internet access. Provide a clear search query.",
		promptSnippet: "Search the web for current information",
		promptGuidelines: [
			"Use web_search when you need to find current information, look up documentation, search for solutions, " +
			"or access anything that requires internet access. Provide a clear search query.",
			"If the search returns no results or unclear results, try refining the query.",
		],
		parameters: Type.Object({
			task: Type.String({
				description: "Search query and context for the web searcher",
			}),
		}),
		async execute(toolCallId, params, signal, onUpdate, _ctx) {
			const task = params.task;

			if (signal?.aborted) {
				return {
					content: [
						{
							type: "text",
							text: "WebSearch was cancelled before it could start.",
						},
					],
					details: { cancelled: true },
					isError: true,
				};
			}

			const result: WebSearchResult = await runWebSearch(
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
			return new Text(theme.fg("toolTitle", theme.bold("web_search")), 0, 0);
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
		pi.setActiveTools([...new Set([...current, "web_search"])]);
	});
}
