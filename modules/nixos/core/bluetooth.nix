{ config, ... }:
{
  flake.modules.nixos = {
    core.imports = [ config.flake.modules.nixos.bluetooth ];

    bluetooth = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
    };
  };
}
