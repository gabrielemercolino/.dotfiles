import { createSubAgentExtension } from "../shared/extension.ts";
import { runWebSearch } from "./runner.ts";
import { formatSummary } from "./format.ts";

export default createSubAgentExtension({
  name: "web_search",
  label: "WebSearch",
  description:
    "Search the web for information. Use when you need to look up current information, documentation, news, " +
    "or anything that requires internet access. Provide a clear search query.",
  promptSnippet: "Search the web for current information",
  promptGuidelines: [
    "Use web_search when you need to find current information, look up documentation, search for solutions, " +
    "or access anything that requires internet access. Provide a clear search query.",
    "If the search returns no results or unclear results, try refining the query.",
  ],
  taskDescription: "Search query and context for the web searcher",
  run: runWebSearch,
  formatSummary,
});
