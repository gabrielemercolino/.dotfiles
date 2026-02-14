{
  config,
  lib,
  ...
}: let
  cfg = config.gab.gaming;
in {
  options.gab.gaming = {
    gamescope.enable = lib.mkEnableOption "gamescope";
  };

  config = {
    programs.gamescope = {
      enable = cfg.gamescope.enable;
      env = {
        "XKB_DEFAULT_LAYOUT" = config.services.xserver.xkb.layout; # IMPORTANT: gamescope uses american keyboard layout by default

        "-W" = "1920"; # window width
        "-H" = "1080"; # window height
        #"-r" = "60";  # max refresh rate
      };
      args = [
        "--mangoapp" # mango hud (mainly for test)
        "-f" # start at full screen
        "--force-windows-fullscreen" # force internal game in full screen
      ];
    };
  };
}
