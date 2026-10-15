{ lib, ... }:
{
  flake.modules.homeManager = {
    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        options.gab.cli.pi.rea = {
          native.enable = lib.mkEnableOption "REA deep native analysis (Ghidra + JDK 21 + procps)";
        };

        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent = {
            extraPackages = [
              pkgs.nodejs
            ]
            # procps: REA needs a procps-compatible `ps` on PATH (Linux
            # owned-process checks). extraPackages appends to the wrapped pi
            # binary's PATH, which MCP servers inherit.
            ++ lib.optionals cfg.rea.native.enable [ pkgs.procps ];
          };

          xdg.configFile."pi/agent/mcp.json".text = builtins.toJSON {
            mcpServers.rea = {
              type = "stdio";
              command = "${pkgs.nodejs}/bin/npx";
              args = [
                "-y"
                "rea-agents@6.5.0"
                "mcp"
              ];
              description = "Reverse engineer native, managed, Electron/JavaScript, packaged, firmware, and browser targets.";
            }
            // lib.optionalAttrs cfg.rea.native.enable {
              env = {
                GHIDRA_INSTALL_DIR = "${pkgs.ghidra}/lib/ghidra";
                JAVA_HOME = "${pkgs.jdk21}";
              };
            };
          };
        };
      };
  };
}
