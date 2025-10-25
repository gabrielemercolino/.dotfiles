{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    kitty.enable = lib.mkEnableOption "kitty";
    warp.enable = lib.mkEnableOption "warp";
    ghostty.enable = lib.mkEnableOption "ghostty";
    alacritty.enable = lib.mkEnableOption "alacritty";
  };

  config = {
    home.packages = lib.optionals cfg.warp.enable [pkgs.warp-terminal];

    programs = {
      alacritty.enable = cfg.alacritty.enable;

      kitty = {
        inherit (cfg.kitty) enable;
        settings = {
          confirm_os_window_close = 0;
          cursor_trail = 10;
        };
      };

      ghostty.enable = cfg.ghostty.enable;
    };
  };
}
