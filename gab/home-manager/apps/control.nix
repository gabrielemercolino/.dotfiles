{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.control;
in
{
  options.gab.apps.control = {
    blueman-applet = lib.mkEnableOption "blueman applet";
  };

  config = {
    home.packages = lib.optionals cfg.blueman-applet [ pkgs.blueman ];
    
    services.blueman-applet.enable = cfg.blueman-applet;
  };
}
