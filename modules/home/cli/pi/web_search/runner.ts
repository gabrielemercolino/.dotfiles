import { Text } from "@earendil-works/pi-tui";
import type { Theme, ToolRenderContext, ToolRenderResultOptions } from "@earendil-works/pi-coding-agent";
import { formatToolCall } from "./format.ts";
import {
	createAgentSession,
	createExtensionRuntime,
	defineTool,
	ModelRuntime,
	SessionManager,
	type ResourceLoader,
} from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";
import { Type } from "typebox";

const WEB_SEARCH_SYSTEM_PROMPT = fs.readFileSync(
	path.join(path.dirname(fileURLToPath(import.meta.url)), "SYSTEM.md"),
	"utf-8",
).trim();

const TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes
const SEARXNG_BASE_URL = "http://localhost:18080";

export interface WebSearchResult {
	output: string;
	exitCode: number | null;
	exitSignal: string | null;
	toolCalls: Array<{ toolName: string; args: Record<string, unknown> }>;
	usage: {
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
	};
	error?: string;
}

const searchTool = defineTool({
	name: "search",
	label: "Search",
	description:
		"Search the web via the SearXNG metasearch engine. Returns formatted " +
		"results with titles, URLs, and content snippets.",
	parameters: Type.Object({
		query: Type.String({ description: "Search query string" }),
		engine: Type.Optional(
			Type.Union([
				Type.Literal("duckduckgo"),
				Type.Literal("wikipedia"),
				Type.Literal("github"),
				Type.Literal("stackoverflow"),
			], { description: "Search engine to use. Defaults to duckduckgo." }),
		),
		pageno: Type.Optional(
			Type.Number({
				description: "Page number for pagination, starts at 1. Defaults to 1.",
			}),
		),
	}),
	execute: async (toolCallId: string, params: { query: string; engine?: string; pageno?: number }, signal: AbortSignal | undefined, onUpdate: any, ctx: any) => {
		const { query, engine, pageno } = params;

		let url =
			`${SEARXNG_BASE_URL}/search?q=${encodeURIComponent(query)}` +
			`&format=json&language=en-US&safesearch=1&pageno=${pageno || 1}`;
		if (engine) {
			url += `&engines=${encodeURIComponent(engine)}`;
		}

		let response: Response;
		try {
			const controller = new AbortController();
			const timeoutId = setTimeout(() => controller.abort(), 10_000);
			try {
				response = await fetch(url, { signal: controller.signal });
			} finally {
				clearTimeout(timeoutId);
			}
		} catch (err: any) {
			if (err?.name === "AbortError") {
				return {
					content: [
						{ type: "text", text: `Search for '${query}' timed out.` },
					],
				};
			}
			return {
				content: [
					{
						type: "text",
						text: `Search failed: ${err?.message ?? String(err)}`,
					},
				],
			};
		}

		if (!response.ok) {
			return {
				content: [
					{
						type: "text",
						text: `Search failed with status ${response.status} (${response.statusText}).`,
					},
				],
			};
		}

		let data: any;
		try {
			data = await response.json();
		} catch {
			return {
				content: [
					{
						type: "text",
						text: "Search failed: invalid JSON response from SearXNG.",
					},
				],
			};
		}

		const results = Array.isArray(data?.results) ? data.results : [];
		if (results.length === 0) {
			return {
				content: [{ type: "text", text: `No results found for '${query}'.` }],
			};
		}

		const formatted = results
			.slice(0, 8)
			.map((r: any) => {
				const title = String(r.title ?? "");
				const link = String(r.url ?? "");
				let content = String(r.content ?? "");
				if (content.length > 1000) {
					content = content.slice(0, 1000);
				}
				return `# ${title}\n${link}\n${content}`;
			})
			.join("\n---\n");

		const links = results.slice(0, 8).map((r: any) => String(r.url ?? "")).filter(Boolean);
		const details = { links };

		return { content: [{ type: "text", text: formatted }], details };
	},
	renderCall: (args: { query: string; engine?: string; pageno?: number }, theme: any, _context: any) => {
		const q = args.query.length > 60 ? args.query.slice(0, 60) + "..." : args.query;
		const engineStr = args.engine ? ` via ${args.engine}` : "";
		return new Text(theme.fg("toolTitle", theme.bold(`searching ${q}${engineStr}`)), 0, 0);
	},
	renderResult: (result: any, _options: any, theme: any, _context: any) => {
		const links: string[] = result.details?.links ?? [];
		if (links.length === 0) {
			return new Text(theme.fg("muted", "no results"), 0, 0);
		}
		const text = links.map((url: string, i: number) => `${i + 1}. ${url}`).join("\n");
		return new Text(text, 0, 0);
	},
});

export async function runWebSearch(
	task: string,
	signal: AbortSignal | undefined,
	onStatus: (status: string) => void,
): Promise<WebSearchResult> {
	const usage = {
		input: 0,
		output: 0,
		cacheRead: 0,
		cacheWrite: 0,
		totalTokens: 0,
		cost: {
			input: 0,
			output: 0,
			cacheRead: 0,
			cacheWrite: 0,
			total: 0,
		},
	};

	// Placeholder abort wiring until we have a session to abort.
	const timeoutId = setTimeout(() => {}, TIMEOUT_MS);
	const onExternalAbort = () => {};
	if (signal) {
		signal.addEventListener("abort", onExternalAbort, { once: true });
	}

	let session: { abort(): Promise<void>; dispose(): void } | undefined;
	let timeout: ReturnType<typeof setTimeout> | undefined;
	let externalAbort: (() => void) | undefined;

	try {
		// Create model runtime and resolve model (prefer deepseek-v4-flash)
		const modelRuntime = await ModelRuntime.create();
		const available = await modelRuntime.getAvailable();
		const webSearchModel =
			available.find(
				(m) => m.provider === "deepseek" && m.id === "deepseek-v4-flash",
			) ?? available[0];

		if (!webSearchModel) {
			clearTimeout(timeoutId);
			if (signal) signal.removeEventListener("abort", onExternalAbort);
			return {
				output: "",
				exitCode: 1,
				exitSignal: null,
				toolCalls: [],
				usage,
				error: "No model available for WebSearch sub-agent",
			};
		}

		const resourceLoader = createWebSearchResourceLoader();

		const { session: createdSession } = await createAgentSession({
			resourceLoader,
			modelRuntime,
			model: webSearchModel,
			tools: ["search"],
			customTools: [searchTool],
			sessionManager: SessionManager.inMemory(),
			thinkingLevel: "off",
		});
		session = createdSession;

		// Wire up real abort handling now that we have the session.
		clearTimeout(timeoutId);
		if (signal) signal.removeEventListener("abort", onExternalAbort);
		const abortSession = () => {
			void session?.abort().catch(() => {});
		};
		timeout = setTimeout(abortSession, TIMEOUT_MS);
		externalAbort = () => {
			abortSession();
		};
		if (signal) {
			signal.addEventListener("abort", externalAbort, { once: true });
		}

		let output = "";

		const done = new Promise<void>((resolve) => {
			session!.subscribe((event) => {
				switch (event.type) {
					case "tool_execution_start": {
						const toolName = event.toolName;
						const args = event.args as Record<string, unknown>;
						onStatus(formatToolCall(toolName, args));
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
		if (externalAbort && signal) signal.removeEventListener("abort", externalAbort);
		session.dispose();

		return {
			output: output.trim() || "WebSearch finished with no output.",
			exitCode: 0,
			exitSignal: null,
			toolCalls: [],
			usage,
		};
	} catch (err: any) {
		clearTimeout(timeoutId);
		if (signal) signal.removeEventListener("abort", onExternalAbort);
		if (timeout) clearTimeout(timeout);
		if (externalAbort && signal) signal.removeEventListener("abort", externalAbort);

		// Check if it's a timeout/abort
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
				toolCalls: [],
				usage,
				error: "WebSearch timed out or was cancelled",
			};
		}

		session?.dispose();
		return {
			output: "",
			exitCode: 1,
			exitSignal: null,
			toolCalls: [],
			usage,
			error: err?.message ?? String(err),
		};
	}
}

function createWebSearchResourceLoader(): ResourceLoader {
	return {
		getExtensions: () => ({ extensions: [], errors: [], runtime: createExtensionRuntime() }),
		getSkills: () => ({ skills: [], diagnostics: [] }),
		getPrompts: () => ({ prompts: [], diagnostics: [] }),
		getThemes: () => ({ themes: [], diagnostics: [] }),
		getAgentsFiles: () => ({ agentsFiles: [] }),
		getSystemPrompt: () => WEB_SEARCH_SYSTEM_PROMPT,
		getSystemPromptSource: () => undefined,
		getAppendSystemPrompt: () => [],
		getAppendSystemPromptSources: () => [],
		extendResources: () => {},
		reload: async () => {},
	};
}
