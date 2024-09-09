{ config, lib, pkgs, systemSettings, userSettings, ... }:

let
  cfg = config.gab.gaming;
in
{

  options.gab.gaming = {
    steam = lib.mkEnableOption {
      default = true;
      description = "Whether to enable steam";
    };
    gamemode = lib.mkEnableOption {
      default = true;
      description = "Whether to enable gamemode";
    };
    gamescope = lib.mkEnableOption {
      default = true;
      description = "Whether to enable gamescope";
    };
  };

  config = {
    programs.steam = {
      enable = cfg.steam;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    programs.gamemode = {
      enable = cfg.gamemode;
      enableRenice = true;
      settings = {
        general = {
          renice = 5;
          igpu_desiredgov = "performance";
        };
      };
    };
    # neeed to make the renice setting work 
    users.users.${userSettings.userName}.extraGroups = [ "gamemode" ];

    programs.gamescope = {
      enable = cfg.gamescope;
      env = {
        "XKB_DEFAULT_LAYOUT" = "${systemSettings.kb.layout}"; # IMPORTANT: gamescope uses american keyboard layout by default

        "-W" = "1980";  # window width
        "-H" = "1080";  # window height
        #"-r" = "60";    # max refresh rate
      };
      args = [
        "--mangoapp"  # mango hud (mainly for test)
        "-f"          # start at full screen
        #"-e"          # enable steam integration
        "--force-windows-fullscreen" # force internal game in full screen
      ];

    };
  };
}
