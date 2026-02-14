{
  config,
  lib,
  ...
}: let
  cfg = config.gab.hardware;
in {
  options.gab.hardware = {
    bluetooth.enable = lib.mkEnableOption "bluetooth";
  };

  config = {
    hardware.bluetooth = {
      inherit (cfg.bluetooth) enable;
      powerOnBoot = false;
    };
  };
}
