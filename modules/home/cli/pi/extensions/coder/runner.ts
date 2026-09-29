import { createSubAgentRunner } from "../shared/subagent.ts";
import { formatToolCall } from "./format.ts";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

const CODER_SYSTEM_PROMPT = fs
  .readFileSync(
    path.join(path.dirname(fileURLToPath(import.meta.url)), "SYSTEM.md"),
    "utf-8",
  )
  .trim();

export const runCoder = createSubAgentRunner({
  name: "coder",
  systemPrompt: CODER_SYSTEM_PROMPT,
  tools: ["read", "write", "edit", "grep", "find", "ls"],
  formatToolCall,
});
