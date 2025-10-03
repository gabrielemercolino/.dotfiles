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
        enable = cfg.sddm.enable;
        enableHidpi = true;
        wayland.enable = true;
        autoNumlock = true;
      };
    };
  };
}
