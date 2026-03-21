{ config, ... }:
{
  flake.modules.nixos = {
    core.imports = [ config.flake.modules.nixos.dbus ];
    dbus =

      { pkgs, ... }:
      {

        services.dbus = {
          enable = true;
          packages = [ pkgs.dconf ];
        };
        programs.dconf.enable = true;
      };
  };
}
