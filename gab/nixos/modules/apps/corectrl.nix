{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    corectrl.enable = lib.mkEnableOption "corectrl";
  };

  config = {
    users.users.${userSettings.userName}.extraGroups = lib.optionals cfg.corectrl.enable ["corectrl"];

    environment.systemPackages = lib.optionals cfg.corectrl.enable [pkgs.lm_sensors];

    programs.corectrl.enable = cfg.corectrl.enable;
  };
}
