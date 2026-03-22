{ config, ... }:
{
  flake.modules.nixos = {
    core.imports = [ config.flake.modules.nixos.graphics ];

    graphics = {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
