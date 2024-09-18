{ pkgs, ... }:

{
  imports = [
    ../base/configuration.nix
    
    ../../system/hardware
    ../../system/apps
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  gab.hardware.bluetooth = true;
  gab.hardware.pipewire = true;
  gab.hardware.i18n.locale = "it_IT.UTF-8";
  gab.hardware.keyboard.layout = "it";
  gab.hardware.time.timeZone = "Europe/Rome";

  gab.apps.dev.direnv = true;
  gab.apps.dev.docker = true;

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
