import { buildFormatSummary } from "../shared/extension.ts";

export function formatToolCall(
  toolName: string,
  args: Record<string, unknown>,
): string {
  switch (toolName) {
    case "search": {
      const q = String(args.query ?? "");
      const short = q.length > 60 ? `${q.slice(0, 60)}...` : q;
      return `searching ${short}`;
    }
    default:
      return toolName;
  }
}

export const formatSummary = buildFormatSummary({
  search: { displayName: "Searched", label: (a) => String(a.query ?? "search") },
});
