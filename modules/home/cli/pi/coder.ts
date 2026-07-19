import { spawn } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";

export default function (pi: ExtensionAPI) {
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
    async execute(_toolCallId, params, signal) {
      return new Promise((resolve) => {
        const proc = spawn(
          "pi",
          [
            "--model",
            "deepseek/deepseek-v4-flash",
            "--print",
            "--no-session",
            params.task,
          ],
          { signal },
        );

        let output = "";
        let stderr = "";

        proc.stdout.on("data", (d: Buffer) => {
          output += d.toString();
        });
        proc.stderr.on("data", (d: Buffer) => {
          stderr += d.toString();
        });

        proc.on("close", (code) => {
          resolve({
            content: [
              {
                type: "text",
                text:
                  output.trim() ||
                  stderr ||
                  `Coder exited with code ${code}`,
              },
            ],
            details: { exitCode: code },
          });
        });

        proc.on("error", (err) => {
          resolve({
            content: [
              {
                type: "text",
                text: `Coder failed to start: ${err.message}`,
              },
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
