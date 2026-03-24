{ self, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.dbus ];

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
