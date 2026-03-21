{ config, lib, ... }:
{
  flake.modules.nixos = {
    apps.imports = [ config.flake.modules.nixos.corectrl ];

    corectrl =
      {
        config,
        pkgs,
        user,
        ...
      }:
      let
        cfg = config.gab.apps.corectrl;
      in
      {
        options.gab.apps.corectrl = {
          enable = lib.mkEnableOption "corectrl";
        };

        config = lib.mkIf cfg.enable {
          users.users.${user.name}.extraGroups = [ "corectrl" ];

          environment.systemPackages = [ pkgs.lm_sensors ];

          programs.corectrl.enable = true;
        };
      };
  };
}
