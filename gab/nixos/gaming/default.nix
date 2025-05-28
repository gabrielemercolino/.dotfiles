{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}: let
  cfg = config.gab.gaming;
in {
  options.gab.gaming = {
    steam.enable = lib.mkEnableOption "steam";
    gamemode.enable = lib.mkEnableOption "gamemode";
    gamescope.enable = lib.mkEnableOption "gamescope";
    rpcs3.enable = lib.mkEnableOption "rpcs3";
    suyu.enable = lib.mkEnableOption "suyu";
  };

  config = {
    environment.systemPackages =
      lib.optionals cfg.suyu.enable [(pkgs.callPackage ./custom-derivations/suyu.nix {})]
      ++ lib.optionals cfg.rpcs3.enable [pkgs.rpcs3];

    # needed to make the renice setting work
    users.users.${userSettings.userName}.extraGroups = lib.optionals cfg.gamemode.enable ["gamemode"];

    programs.steam = {
      enable = cfg.steam.enable;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    programs.gamemode = {
      enable = cfg.gamemode.enable;
      enableRenice = true;
      settings = {
        general = {
          renice = 5;
          igpu_desiredgov = "performance";
        };
      };
    };

    programs.gamescope = {
      enable = cfg.gamescope.enable;
      env = {
        "XKB_DEFAULT_LAYOUT" = config.services.xserver.xkb.layout; # IMPORTANT: gamescope uses american keyboard layout by default

        "-W" = "1980"; # window width
        "-H" = "1080"; # window height
        #"-r" = "60";    # max refresh rate
      };
      args = [
        "--mangoapp" # mango hud (mainly for test)
        "-f" # start at full screen
        #"-e"          # enable steam integration
        "--force-windows-fullscreen" # force internal game in full screen
      ];
    };
  };
}
