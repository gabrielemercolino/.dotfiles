{lib, ...}: {
  flake.homeModules.apps = {config, ...}: let
    cfg = config.gab.apps.opencode;

    antigravity-cfg = builtins.readFile ./antigravity.json |> builtins.fromJSON;
  in {
    options.gab.apps.opencode = {
      enable = lib.mkEnableOption "opencode";
      plugins = {
        antigravity.enable = lib.mkEnableOption "opencode antigravity auth & models";
      };
    };

    config = lib.mkIf cfg.enable {
      programs.opencode = {
        enable = true;

        settings = with cfg.plugins; {
          plugin = lib.optionals antigravity.enable antigravity-cfg.plugin;
          provider = lib.mkMerge [
            (lib.optionals antigravity.enable antigravity-cfg.provider)
          ];
        };
      };
    };
  };
}
