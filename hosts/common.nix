{self, ...}: let
  stateVersion = "26.05";
in {
  flake.nixosModules.common = {...}: {
    imports = [
      self.nixosModules.user
      self.nixosModules.wm
      # self.nixosModules.apps
      self.nixosModules.gaming
    ];
    boot = {
      initrd.systemd.enable = true;
      initrd.systemd.emergencyAccess = true;
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
    };

    system.stateVersion = stateVersion;

    nix.settings = {
      experimental-features = ["nix-command" "flakes" "pipe-operators"];
      auto-optimise-store = true;
    };

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  flake.homeModules.common = {...}: {
    imports = [
      self.homeModules.gab
      self.homeModules.user
      self.homeModules.wm
    ];

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    home.stateVersion = stateVersion;
  };
}
