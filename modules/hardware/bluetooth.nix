{
  self,
  lib,
  ...
}: {
  flake.nixosModules.bluetooth = {config, ...}: let
    cfg = config.gab.hardware.bluetooth;
  in {
    options.gab.hardware.bluetooth = {
      enable = lib.mkEnableOption "bluetooth";
      onBoot = lib.mkEnableOption "bluetooth on boot";
    };

    config = lib.mkIf cfg.enable {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = cfg.onBoot;
      };
    };
  };

  flake.nixosModules.hardware = _: {imports = [self.nixosModules.bluetooth];};
}
