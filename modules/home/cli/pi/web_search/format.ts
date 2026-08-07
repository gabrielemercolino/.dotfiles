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

export function formatSummary(
	toolCalls: Array<{ toolName: string; args: Record<string, unknown> }>,
	output = "",
): string {
	const groups = new Map<string, string[]>();

	for (const call of toolCalls) {
		const group = groups.get(call.toolName) ?? [];
		let label = "";
		switch (call.toolName) {
			case "search":
				label = String(call.args.query ?? call.toolName);
				break;
			default:
				label = call.toolName;
				break;
		}
		group.push(label);
		groups.set(call.toolName, group);
	}

	const lines: string[] = [];
	for (const [toolName, items] of groups) {
		const displayName =
			toolName === "search"
				? "Searched"
				: toolName.charAt(0).toUpperCase() + toolName.slice(1);
		lines.push(`${displayName} ${items.join(", ")}`);
	}

	const parts: string[] = [];
	const trimmedOutput = output.trim();
	if (trimmedOutput) {
		parts.push(trimmedOutput);
	}

	const toolSummary = lines.join("\n");
	if (toolSummary) {
		parts.push(toolSummary);
	}

	return parts.join("\n\n");
}
