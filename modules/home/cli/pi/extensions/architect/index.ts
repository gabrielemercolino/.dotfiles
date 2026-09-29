import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const MODIFICATION_TOOLS = ["write", "edit", "bash"];
const READONLY_TOOLS = ["ls", "grep", "find", "read"];

export default function (pi: ExtensionAPI) {
  pi.on("session_start", () => {
    const current = pi.getActiveTools();
    const filtered = current.filter(t => !MODIFICATION_TOOLS.includes(t));
    pi.setActiveTools([...new Set([...filtered, ...READONLY_TOOLS])]);
  });
}
