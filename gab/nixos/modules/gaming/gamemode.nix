{
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.gab.gaming;
in {
  options.gab.gaming = {
    gamemode.enable = lib.mkEnableOption "gamemode";
  };

  config = {
    # needed to make the renice setting work
    users.users.${userSettings.userName}.extraGroups = lib.optionals cfg.gamemode.enable ["gamemode"];

    programs.gamemode = {
      inherit (cfg.gamemode) enable;
      enableRenice = true;
      settings = {
        general = {
          renice = 5;
          igpu_desiredgov = "performance";
        };
      };
    };
  };
}
