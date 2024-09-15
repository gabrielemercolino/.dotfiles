{ pkgs, ... }:

{
  imports = [
    ../base/configuration.nix
    
    ../../system/hardware

    # development
    ../../system/virtualization/docker.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  gab.hardware.bluetooth = true;
  gab.hardware.pipewire = true;

  # I'm not building hyprland on a Pentium 💀
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';
}
