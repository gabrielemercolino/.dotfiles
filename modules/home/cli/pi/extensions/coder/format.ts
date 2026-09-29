import { buildFormatSummary } from "../shared/extension.ts";
import * as path from "node:path";

export function formatToolCall(
  toolName: string,
  args: Record<string, unknown>,
): string {
  switch (toolName) {
    case "write": {
      const filePath = String(args.file_path ?? args.path ?? "");
      return `writing ${path.basename(filePath)}`;
    }
    case "edit": {
      const filePath = String(args.file_path ?? args.path ?? "");
      return `editing ${path.basename(filePath)}`;
    }
    case "read": {
      const filePath = String(args.file_path ?? args.path ?? "");
      return `reading ${path.basename(filePath)}`;
    }
    case "bash": {
      const cmd = String(args.command ?? "");
      if (cmd.length > 60) {
        return `running ${cmd.slice(0, 60)}...`;
      }
      return `running ${cmd}`;
    }
    case "grep": {
      return `searching for ${args.pattern} in ${args.path ?? ""}`;
    }
    case "find": {
      return `finding ${args.pattern ?? ""} in ${args.path ?? ""}`;
    }
    case "ls": {
      return `listing ${args.path ?? ""}`;
    }
    default:
      return toolName;
  }
}

export const formatSummary = buildFormatSummary({
  write: { displayName: "Wrote", label: (a) => String(a.file_path ?? a.path ?? "write") },
  edit: { displayName: "Edited", label: (a) => String(a.file_path ?? a.path ?? "edit") },
  read: { displayName: "Read", label: (a) => String(a.file_path ?? a.path ?? "read") },
});
