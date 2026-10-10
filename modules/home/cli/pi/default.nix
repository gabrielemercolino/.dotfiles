{ self, lib, ... }:
{
  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.pi ];

    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
        agentDir = "${config.xdg.configHome}/pi/agent";
      in
      {
        options.gab.cli.pi = {
          enable = lib.mkEnableOption "pi coding agent";
        };

        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent = {
            enable = true;
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
