import { createSubAgentExtension } from "../shared/extension.ts";
import { runCoder } from "./runner.ts";
import { formatSummary } from "./format.ts";

export default createSubAgentExtension({
  name: "coder",
  label: "Coder",
  description:
    "Delegate code implementation to the coder. " +
    "Use when the user agrees on a plan and wants code written. " +
    "Provide clear, specific instructions.",
  promptSnippet: "Delegate code implementation",
  promptGuidelines: [
    "Use coder when the user indicates they want to proceed with implementation " +
    "'implement this', 'go ahead', 'let's do it', 'make the changes', 'use the coder', etc.).",
    "Provide clear, specific instructions.",
  ],
  taskDescription: "Detailed implementation instructions for the coder",
  run: runCoder,
  formatSummary,
});
