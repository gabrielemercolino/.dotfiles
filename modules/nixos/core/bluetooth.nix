{ self, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.bluetooth ];

    bluetooth = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };
    };
  };
}
