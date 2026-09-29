import { Text } from "@earendil-works/pi-tui";
import type {
  Theme,
  ToolRenderContext,
  ToolRenderResultOptions,
} from "@earendil-works/pi-coding-agent";
import { defineTool } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { createSubAgentRunner } from "../shared/subagent.ts";
import { formatToolCall } from "./format.ts";
import * as fs from "node:fs";
import * as path from "node:path";
import { fileURLToPath } from "node:url";

const WEB_SEARCH_SYSTEM_PROMPT = fs
  .readFileSync(
    path.join(path.dirname(fileURLToPath(import.meta.url)), "SYSTEM.md"),
    "utf-8",
  )
  .trim();

const SEARXNG_BASE_URL = "http://localhost:18080";

const searchTool = defineTool({
  name: "search",
  label: "Search",
  description:
    "Search the web via the SearXNG metasearch engine. Returns formatted " +
    "results with titles, URLs, and content snippets.",
  parameters: Type.Object({
    query: Type.String({ description: "Search query string" }),
    engine: Type.Optional(
      Type.Union(
        [
          Type.Literal("duckduckgo"),
          Type.Literal("wikipedia"),
          Type.Literal("github"),
          Type.Literal("stackoverflow"),
        ],
        { description: "Search engine to use. Defaults to duckduckgo." },
      ),
    ),
    pageno: Type.Optional(
      Type.Number({
        description: "Page number for pagination, starts at 1. Defaults to 1.",
      }),
    ),
  }),
  execute: async (
    toolCallId: string,
    params: { query: string; engine?: string; pageno?: number },
    signal: AbortSignal | undefined,
    onUpdate: any,
    ctx: any,
  ) => {
    const { query, engine, pageno } = params;

    let url =
      `${SEARXNG_BASE_URL}/search?q=${encodeURIComponent(query)}` +
      `&format=json&language=en-US&safesearch=1&pageno=${pageno || 1}`;
    if (engine) {
      url += `&engines=${encodeURIComponent(engine)}`;
    }

    let response: Response;
    try {
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 10_000);
      try {
        response = await fetch(url, { signal: controller.signal });
      } finally {
        clearTimeout(timeoutId);
      }
    } catch (err: any) {
      if (err?.name === "AbortError") {
        return {
          content: [{ type: "text", text: `Search for '${query}' timed out.` }],
        };
      }
      return {
        content: [
          {
            type: "text",
            text: `Search failed: ${err?.message ?? String(err)}`,
          },
        ],
      };
    }

    if (!response.ok) {
      return {
        content: [
          {
            type: "text",
            text: `Search failed with status ${response.status} (${response.statusText}).`,
          },
        ],
      };
    }

    let data: any;
    try {
      data = await response.json();
    } catch {
      return {
        content: [
          {
            type: "text",
            text: "Search failed: invalid JSON response from SearXNG.",
          },
        ],
      };
    }

    const results = Array.isArray(data?.results) ? data.results : [];
    if (results.length === 0) {
      return {
        content: [{ type: "text", text: `No results found for '${query}'.` }],
      };
    }

    const formatted = results
      .slice(0, 8)
      .map((r: any) => {
        const title = String(r.title ?? "");
        const link = String(r.url ?? "");
        let content = String(r.content ?? "");
        if (content.length > 1000) {
          content = content.slice(0, 1000);
        }
        return `# ${title}\n${link}\n${content}`;
      })
      .join("\n---\n");

    const links = results
      .slice(0, 8)
      .map((r: any) => String(r.url ?? ""))
      .filter(Boolean);
    const details = { links };

    return { content: [{ type: "text", text: formatted }], details };
  },
  renderCall: (
    args: { query: string; engine?: string; pageno?: number },
    theme: any,
    _context: any,
  ) => {
    const q = args.query.length > 60 ? args.query.slice(0, 60) + "..." : args.query;
    const engineStr = args.engine ? ` via ${args.engine}` : "";
    return new Text(
      theme.fg("toolTitle", theme.bold(`searching ${q}${engineStr}`)),
      0,
      0,
    );
  },
  renderResult: (result: any, _options: any, theme: any, _context: any) => {
    const links: string[] = result.details?.links ?? [];
    if (links.length === 0) {
      return new Text(theme.fg("muted", "no results"), 0, 0);
    }
    const text = links
      .map((url: string, i: number) => `${i + 1}. ${url}`)
      .join("\n");
    return new Text(text, 0, 0);
  },
});

export const runWebSearch = createSubAgentRunner({
  name: "web_search",
  systemPrompt: WEB_SEARCH_SYSTEM_PROMPT,
  tools: ["search"],
  customTools: [searchTool],
  formatToolCall,
});
