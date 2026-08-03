import { formatToolCall } from "./format.ts";
import {
	createAgentSession,
	createExtensionRuntime,
	ModelRuntime,
	SessionManager,
	type ResourceLoader,
} from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

const BASHER_SYSTEM_PROMPT = fs.readFileSync(
	path.join(path.dirname(fileURLToPath(import.meta.url)), "SYSTEM.md"),
	"utf-8",
).trim();

const TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes

export interface BasherResult {
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

export async function runBasher(
	task: string,
	signal: AbortSignal | undefined,
	onStatus: (status: string) => void,
): Promise<BasherResult> {
	const toolCalls: Array<{ toolName: string; args: Record<string, unknown> }> = [];
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
		const basherModel =
			available.find(
				(m) => m.provider === "deepseek" && m.id === "deepseek-v4-flash",
			) ?? available[0];

		if (!basherModel) {
			clearTimeout(timeoutId);
			if (signal) signal.removeEventListener("abort", onExternalAbort);
			return {
				output: "",
				exitCode: 1,
				exitSignal: null,
				toolCalls: [],
				usage,
				error: "No model available for basher sub-agent",
			};
		}

		const resourceLoader = createBasherResourceLoader();

		const { session: createdSession } = await createAgentSession({
			resourceLoader,
			modelRuntime,
			model: basherModel,
			tools: ["bash", "read", "grep", "find", "ls"],
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
		if (externalAbort && signal) signal.removeEventListener("abort", externalAbort);
		session.dispose();

		return {
			output: output.trim() || "Basher finished with no output.",
			exitCode: 0,
			exitSignal: null,
			toolCalls,
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
				toolCalls,
				usage,
				error: "Basher timed out or was cancelled",
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
}

function createBasherResourceLoader(): ResourceLoader {
	return {
		getExtensions: () => ({ extensions: [], errors: [], runtime: createExtensionRuntime() }),
		getSkills: () => ({ skills: [], diagnostics: [] }),
		getPrompts: () => ({ prompts: [], diagnostics: [] }),
		getThemes: () => ({ themes: [], diagnostics: [] }),
		getAgentsFiles: () => ({ agentsFiles: [] }),
		getSystemPrompt: () => BASHER_SYSTEM_PROMPT,
		getSystemPromptSource: () => undefined,
		getAppendSystemPrompt: () => [],
		getAppendSystemPromptSources: () => [],
		extendResources: () => {},
		reload: async () => {},
	};
}
