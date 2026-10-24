{ self, lib, ... }:
{
  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.pi ];

    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
        agentDir = "${config.xdg.configHome}/pi/agent";
        realPi = pkgs.pi-coding-agent;

        piWithEnv = pkgs.writeShellScriptBin "pi" (
          cfg.envFiles
          |> builtins.map (f: "[ -r ${lib.escapeShellArg f} ] && . ${lib.escapeShellArg f}")
          |> lib.concatStringsSep "\n"
          |> (lines: lines + "\nexec ${lib.getExe realPi} \"$@\"\n")
        );
      in
      {
        options.gab.cli.pi = {
          enable = lib.mkEnableOption "pi coding agent";

          envFiles = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Files sourced when pi launches. Meant to be used with sops templates            ";
          };
        };

        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent = {
            enable = true;
            package = piWithEnv;
            configDir = agentDir;
            settings = {
              defaultProvider = "deepseek";
              defaultModel = "deepseek-v4-pro";
              defaultThinkingLevel = "high";
              markdown.mermaid = "final";
            };
            appendSystem = ./APPEND_SYSTEM.md;
          };

          sops.secrets."deepseek/key" = { };

          xdg.configFile."pi/agent/auth.json".text = builtins.toJSON {
            deepseek = {
              type = "api_key";
              key = "!cat ${config.sops.secrets."deepseek/key".path}";
            };
          };
        };
      };
  };
}
