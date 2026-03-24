{ config, lib, ... }:
{
  flake.modules.nixos = {
    gaming.imports = [ config.flake.modules.nixos.gamescope ];

    gamescope =
      { config, pkgs, ... }:
      let
        cfg = config.gab.gaming.gamescope;
      in
      {
        options.gab.gaming.gamescope = {
          enable = lib.mkEnableOption "gamescope";
        };

        config = lib.mkIf cfg.enable {
          programs.gamescope = {
            enable = true;
            env = {
              # IMPORTANT: gamescope uses american keyboard layout by default
              "XKB_DEFAULT_LAYOUT" = config.services.xserver.xkb.layout;

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
      };
  };
}
