{
  self,
  lib,
  ...
}: {
  flake.nixosModules.docker = {config, ...}: let
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

  flake.nixosModules.apps = _: {imports = [self.nixosModules.docker];};
}
