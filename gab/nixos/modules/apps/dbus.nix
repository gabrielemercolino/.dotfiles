{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    dbus.enable = lib.mkEnableOption "dbus";
  };

  config = {
    services.dbus = {
      enable = cfg.dbus.enable;
      packages = [pkgs.dconf];
    };
    programs.dconf.enable = cfg.dbus.enable;
  };
}
