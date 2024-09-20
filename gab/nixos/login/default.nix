{ config, lib, pkgs, ... }:

let
  cfg = config.gab.login;
in
{
  options.gab.login = {
    sddm = lib.mkEnableOption "sddm";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.sddm [ pkgs.libsForQt5.qt5.qtquickcontrols2 pkgs.libsForQt5.qt5.qtgraphicaleffects ];
    services.displayManager = {
      sddm = {
        enable = cfg.sddm;
        enableHidpi = true;
        wayland.enable = true;
        autoNumlock = true;
        package = pkgs.sddm; 
      };
    };
  };
}
