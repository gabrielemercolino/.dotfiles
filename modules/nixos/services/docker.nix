{ self, lib, ... }:
{
  flake.modules.nixos = {
    services.imports = [ self.modules.nixos.docker ];

    docker =
      {
        config,
        pkgs,
        user,
        ...
      }:
      let
        cfg = config.gab.services.docker;
      in
      {
        options.gab.services.docker = {
          enable = lib.mkEnableOption "docker";
        };

        config = lib.mkIf cfg.enable {
          users.users.${user.name}.extraGroups = [ "docker" ];

          virtualisation.docker.enable = true;
        };
      };
  };
}
