{ pkgs, ... }:

{
  imports = [
    ../base/configuration.nix
    ../../gab
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # use zsh
  users.defaultUserShell = [ pkgs.zsh ];

  gab.login.sddm = true;

  gab.hardware.bluetooth        = true;
  gab.hardware.pipewire         = true;
  gab.hardware.i18n.locale      = "it_IT.UTF-8";
  gab.hardware.keyboard.layout  = "it";
  gab.hardware.time.timeZone    = "Europe/Rome";

  gab.apps.security.ssh   = true;
  gab.apps.services.dbus  = true;
  gab.apps.dev.direnv     = true;
  gab.apps.dev.docker     = true;

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
