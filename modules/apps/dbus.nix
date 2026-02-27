{lib, ...}: {
  flake.nixosModules.apps = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.dbus;
  in {
    options.gab.apps.dbus = {
      enable = lib.mkEnableOption "dbus";
    };

    config = lib.mkIf cfg.enable {
      services.dbus = {
        enable = true;
        packages = [pkgs.dconf];
      };

      programs.dconf.enable = true;
    };
  };
}
