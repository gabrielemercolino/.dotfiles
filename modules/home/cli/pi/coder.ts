import { spawn } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

const TIMEOUT_MS = 5 * 60 * 1000; // 5 minutes

function getPiInvocation(args: string[]): {
	command: string;
	args: string[];
} {
	const currentScript = process.argv[1];
	const isBunVirtualScript = currentScript?.startsWith("/$bunfs/root/");
	if (currentScript && !isBunVirtualScript && fs.existsSync(currentScript)) {
		return { command: process.execPath, args: [currentScript, ...args] };
	}

	const execName = path.basename(process.execPath).toLowerCase();
	const isGenericRuntime = /^(node|bun)(\.exe)?$/.test(execName);
	if (!isGenericRuntime) {
		return { command: process.execPath, args };
	}

	return { command: "pi", args };
}

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

			const args = [
				"--model",
				"deepseek/deepseek-v4-flash",
				"--print",
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

				proc.stdout.on("data", (d: Buffer) => {
					output += d.toString();
					onUpdate?.({ content: [{ type: "text", text: output.slice(-500) }] });
				});

				proc.stderr.on("data", (d: Buffer) => {
					stderr += d.toString();
				});

				proc.on("close", (code, exitSignal) => {
					resolve({
						content: [
							{
								type: "text",
								text:
									output.trim() ||
									stderr.trim() ||
									`Coder exited with code ${code}${exitSignal ? ` (signal: ${exitSignal})` : ""}`,
							},
						],
						details: { exitCode: code, signal: exitSignal },
					});
				});

				proc.on("error", (err) => {
					resolve({
						content: [
							{ type: "text", text: `Coder failed to start: ${err.message}` },
						],
						details: { error: err.message },
						isError: true,
					});
				});
			});
		},
	});

	pi.on("session_start", () => {
		pi.setActiveTools(["read", "grep", "find", "ls", "coder"]);
	});
}
