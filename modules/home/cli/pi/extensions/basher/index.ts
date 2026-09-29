import { createSubAgentExtension } from "../shared/extension.ts";
import { runBasher } from "./runner.ts";
import { formatSummary } from "./format.ts";

export default createSubAgentExtension({
  name: "basher",
  label: "Basher",
  description:
    "Delegate CLI operations to the basher. " +
    "Use when you need to inspect directories, run chains of shell commands, or perform file operations. " +
    "The basher will verify safety before executing. " +
    "Provide a clear description of what you need done.",
  promptSnippet: "Delegate CLI operations",
  promptGuidelines: [
    "Use basher when you need to perform CLI operations — inspecting directories, removing files, " +
    "running chains of shell commands. Describe the task in natural language; the basher will inspect, " +
    "verify safety, and execute.",
    "If the basher refuses, read its explanation carefully. You may need to clarify " +
    "the task or ask the user for more information.",
  ],
  taskDescription: "Detailed instructions for the basher",
  run: runBasher,
  formatSummary,
});
