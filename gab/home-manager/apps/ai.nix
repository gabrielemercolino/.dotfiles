{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps;

  antigravity-cfg = builtins.readFile ./configs/opencode/antigravity.json |> builtins.fromJSON;
in {
  options.gab.apps = {
    opencode = {
      enable = lib.mkEnableOption "opencode";
      plugins = {
        antigravity.enable = lib.mkEnableOption "antigravity auth & models";
      };
    };
  };

  config = {
    programs.opencode = {
      inherit (cfg.opencode) enable;
      settings = with cfg.opencode.plugins; {
        plugin = lib.optionals antigravity.enable antigravity-cfg.plugin;
        provider = lib.mkMerge [
          (lib.optionals antigravity.enable antigravity-cfg.provider)
        ];
      };
    };
  };
}
