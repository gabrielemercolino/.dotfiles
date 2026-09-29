import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

const ARCHITECT_PROMPT = fs
  .readFileSync(
    path.join(path.dirname(fileURLToPath(import.meta.url)), "SYSTEM.md"),
    "utf-8",
  )
  .trim();

const MODIFICATION_TOOLS = ["write", "edit", "bash"];
const READONLY_TOOLS = ["ls", "grep", "find", "read"];

export default function (pi: ExtensionAPI) {
  pi.on("session_start", () => {
    const current = pi.getActiveTools();
    const filtered = current.filter((t) => !MODIFICATION_TOOLS.includes(t));
    pi.setActiveTools([...new Set([...filtered, ...READONLY_TOOLS])]);
  });

  pi.on("before_agent_start", (event) => ({
    systemPrompt: event.systemPrompt + "\n\n" + ARCHITECT_PROMPT,
  }));
}
