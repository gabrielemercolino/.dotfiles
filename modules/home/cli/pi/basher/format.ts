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

export function formatSummary(
	toolCalls: Array<{ toolName: string; args: Record<string, unknown> }>,
	output = "",
): string {
	const groups = new Map<string, string[]>();

	for (const call of toolCalls) {
		const group = groups.get(call.toolName) ?? [];
		let label = "";
		switch (call.toolName) {
			case "bash": {
				const cmd = String(call.args.command ?? "");
				label = cmd.length > 60 ? `${cmd.slice(0, 60)}...` : cmd;
				break;
			}
			case "read":
				label = String(
					call.args.file_path ?? call.args.path ?? call.toolName,
				);
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
			toolName === "bash"
				? "Ran"
				: toolName === "read"
					? "Read"
					: toolName === "grep"
						? "Searched"
						: toolName === "find"
							? "Found"
							: toolName === "ls"
								? "Listed"
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
