{self, ...}: let
  stateVersion = "26.05";
in {
  flake.nixosModules.common = {...}: {
    imports = with self.nixosModules; [host user hardware wm apps clis gaming fonts sops];

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
    imports = with self.homeModules; [user hardware apps clis socials browsers music wm sops];

    nixpkgs.config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };

    home.packages = [self.packages.${system}.gab];

    home.stateVersion = stateVersion;
  };
}
