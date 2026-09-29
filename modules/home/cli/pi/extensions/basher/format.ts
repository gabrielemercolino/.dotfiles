import { buildFormatSummary } from "../shared/extension.ts";
import * as path from "node:path";

export function formatToolCall(
  toolName: string,
  args: Record<string, unknown>,
): string {
  switch (toolName) {
    case "bash": {
      const cmd = String(args.command ?? "");
      if (cmd.length > 60) {
        return `running ${cmd.slice(0, 60)}...`;
      }
      return `running ${cmd}`;
    }
    case "read": {
      const filePath = String(args.file_path ?? args.path ?? "");
      return `reading ${path.basename(filePath)}`;
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
  bash: {
    displayName: "Ran",
    label: (a) => {
      const cmd = String(a.command ?? "");
      return cmd.length > 60 ? `${cmd.slice(0, 60)}...` : cmd;
    },
  },
  read: {
    displayName: "Read",
    label: (a) => String(a.file_path ?? a.path ?? "read"),
  },
  grep: { displayName: "Searched" },
  find: { displayName: "Found" },
  ls: { displayName: "Listed" },
});
