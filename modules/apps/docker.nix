{
  self,
  lib,
  ...
}: {
  flake.nixosModules.apps = {config, ...}: let
    cfg = config.gab.apps.docker;
  in {
    imports = [self.nixosModules.user];

    options.gab.apps.docker = {
      enable = lib.mkEnableOption "docker";
    };

    config = lib.mkIf cfg.enable {
      users.users.${config.gab.user.name}.extraGroups = ["docker"];

      virtualisation.docker.enable = true;
    };
  };
}
