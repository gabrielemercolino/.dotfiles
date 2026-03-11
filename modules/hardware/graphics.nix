{self, ...}: {
  flake.nixosModules.graphics = {...}: {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  flake.nixosModules.hardware = _: {imports = [self.nixosModules.graphics];};
}
