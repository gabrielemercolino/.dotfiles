{ pkgs, ... }:

{
  imports = [
    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # use zsh
  users.defaultUserShell  = pkgs.zsh;
  programs.zsh.enable     = true;

  gab.login.sddm = true;

  gab.hardware.bluetooth        = true;
  gab.hardware.pipewire         = true;
  gab.hardware.i18n.locale      = "it_IT.UTF-8";
  gab.hardware.keyboard.layout  = "it";
  gab.hardware.time.timeZone    = "Europe/Rome";

  gab.apps.wm.hyprland      = true;
  gab.apps.security.ssh     = true;
  gab.apps.services.dbus    = true;
  gab.apps.control.corectrl = true;
  #gab.apps.control.lact     = true;
  gab.apps.dev.direnv       = true;
  gab.apps.dev.docker       = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  services.xserver.excludePackages = [ pkgs.xterm ];
}
