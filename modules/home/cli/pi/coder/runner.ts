import { spawn } from "node:child_process";
import { getPiInvocation, formatToolCall } from "./format.ts";

const TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes

export interface CoderResult {
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

export async function runCoder(
	task: string,
	signal: AbortSignal | undefined,
	onStatus: (status: string) => void,
): Promise<CoderResult> {
	const args = [
		"--model",
		"deepseek/deepseek-v4-flash",
		"--mode",
		"json",
		"-p",
		"--no-session",
		task,
	];

	const invocation = getPiInvocation(args);

	const timeoutSignal = AbortSignal.timeout(TIMEOUT_MS);
	const combinedSignal = signal
		? AbortSignal.any([signal, timeoutSignal])
		: timeoutSignal;

	return new Promise((resolve) => {
		const proc = spawn(invocation.command, invocation.args, {
			signal: combinedSignal,
			stdio: ["ignore", "pipe", "pipe"],
			env: { ...process.env, PI_CODER_DISABLED: "1" },
		});

		const killWithEscalation = () => {
			proc.kill("SIGTERM");
			setTimeout(() => {
				if (!proc.killed) proc.kill("SIGKILL");
			}, 5000);
		};
		combinedSignal.addEventListener("abort", killWithEscalation, {
			once: true,
		});

		let output = "";
		let stderr = "";
		const toolCalls: Array<{
			toolName: string;
			args: Record<string, unknown>;
		}> = [];
		let buffer = "";
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

		proc.stdout.on("data", (d: Buffer) => {
			buffer += d.toString();

			const lines = buffer.split("\n");
			// Keep the last (potentially incomplete) line in the buffer
			buffer = lines.pop() ?? "";

			for (const line of lines) {
				const trimmed = line.trim();
				if (!trimmed) continue;

				try {
					const event = JSON.parse(trimmed);
					if (event.type === "tool_execution_start") {
						const status = formatToolCall(event.toolName, event.args);
						onStatus(status);
						toolCalls.push({
							toolName: event.toolName,
							args: event.args,
						});
					} else if (event.type === "message_end") {
						const msg = event.message;
						if (msg?.role === "assistant" && Array.isArray(msg.content)) {
							for (const block of msg.content) {
								if (block.type === "text") {
									output += block.text;
								}
							}
						}
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
					}
				} catch {
					// Skip lines that are not valid JSON
				}
			}
		});

		proc.stderr.on("data", (d: Buffer) => {
			stderr += d.toString();
		});

		proc.on("close", (code, exitSignal) => {
			const result: CoderResult = {
				output:
					output.trim() ||
					stderr.trim() ||
					`Coder exited with code ${code}${exitSignal ? ` (signal: ${exitSignal})` : ""}`,
				exitCode: code,
				exitSignal,
				toolCalls,
				usage,
			};
			resolve(result);
		});

		proc.on("error", (err) => {
			resolve({
				output: "",
				exitCode: null,
				exitSignal: null,
				toolCalls: [],
				usage,
				error: err.message,
			});
		});
	});
}
