import { createSubAgentRunner } from "../shared/subagent.ts";
import { formatToolCall } from "./format.ts";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

const BASHER_SYSTEM_PROMPT = fs
  .readFileSync(
    path.join(path.dirname(fileURLToPath(import.meta.url)), "SYSTEM.md"),
    "utf-8",
  )
  .trim();

export const runBasher = createSubAgentRunner({
  name: "basher",
  systemPrompt: BASHER_SYSTEM_PROMPT,
  tools: ["bash", "read", "grep", "find", "ls"],
  formatToolCall,
});
