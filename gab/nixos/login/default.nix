{
  config,
  lib,
  ...
}: let
  cfg = config.gab.login;
in {
  options.gab.login = {
    sddm.enable = lib.mkEnableOption "sddm";
  };

  config = {
    services.displayManager = {
      sddm = {
        enable = lib.mkForce cfg.sddm.enable;
        enableHidpi = lib.mkForce true;
        wayland.enable = lib.mkForce true;
        autoNumlock = lib.mkForce true;
      };
    };
  };
}
