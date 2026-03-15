{ config, ... }:
{
  flake.modules.nixos = {
    boot = {
      boot = {
        initrd = {
          systemd.enable = true;
          systemd.emergencyAccess = true;
        };

        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };
    };

    core.imports = [ config.flake.modules.nixos.boot ];
  };
}
