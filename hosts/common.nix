{self, ...}: let
  stateVersion = "26.05";
in {
  flake.nixosModules.common = {...}: {
    imports = [
      self.nixosModules.hardware
      self.nixosModules.user
      self.nixosModules.wm
      self.nixosModules.apps
      self.nixosModules.clis
      self.nixosModules.gaming
      self.nixosModules.fonts
      self.nixosModules.sops
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

  flake.homeModules.common = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
  in {
    imports = [
      self.homeModules.user
      self.homeModules.keyboard
      self.homeModules.apps
      self.homeModules.clis
      self.homeModules.socials
      self.homeModules.browsers
      self.homeModules.music
      self.homeModules.wm
      self.homeModules.sops
    ];

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    home.packages = [self.packages.${system}.gab];

    home.stateVersion = stateVersion;
  };
}
