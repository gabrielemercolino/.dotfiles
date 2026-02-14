{
  config,
  lib,
  userSettings,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    docker.enable = lib.mkEnableOption "docker";
  };

  config = {
    users.users.${userSettings.userName}.extraGroups = lib.optionals cfg.docker.enable ["docker"];

    virtualisation.docker.enable = cfg.docker.enable;
  };
}
