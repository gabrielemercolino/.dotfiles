{ lib, ... }:
{
  flake.modules.homeManager = {
    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent = {
            extraPackages = [ pkgs.nodejs ];
            settings.packages = [ "npm:pi-custom-compaction" ];
          };

          xdg.configFile."pi/agent/compaction-policy.json".text = builtins.toJSON {
            enabled = true;
            trigger.maxTokens = 250000;
            summaryRetention = {
              mode = "tokens";
              value = 40000;
            };
            models = [
              "deepseek/deepseek-flash"
              "deepseek/deepseek-v4-pro"
            ];
          };

          # pi-custom-compaction hardcodes its global config to ~/.pi/agent/,
          # ignoring PI_CODING_AGENT_DIR. Symlink so the canonical file stays
          # under ~/.config/pi/agent.
          home.file.".pi/agent/compaction-policy.json".source =
            config.lib.file.mkOutOfStoreSymlink "${config.xdg.configHome}/pi/agent/compaction-policy.json";
        };
      };
  };
}
