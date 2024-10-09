{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    blueman-applet.enable = lib.mkEnableOption "blueman applet";
  };

  config = {
    home.packages = lib.optionals cfg.blueman-applet.enable [ pkgs.blueman ];
    services.blueman-applet.enable = cfg.blueman-applet.enable;
  };
}
