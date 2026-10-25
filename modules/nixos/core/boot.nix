{ self, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.boot ];

    boot = {
      boot = {
        initrd = {
          systemd.emergencyAccess = true;
        };

        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };
    };
  };
}
