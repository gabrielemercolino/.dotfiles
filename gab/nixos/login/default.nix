{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.login;
in {
  options.gab.login = {
    sddm.enable = lib.mkEnableOption "sddm";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.sddm.enable [
      pkgs.libsForQt5.qt5.qtquickcontrols2
      pkgs.libsForQt5.qt5.qtgraphicaleffects
    ];

    services.displayManager = {
      sddm = {
        enable = cfg.sddm.enable;
        enableHidpi = true;
        wayland.enable = true;
        autoNumlock = true;
        package = pkgs.libsForQt5.sddm;
      };
    };
  };
}
