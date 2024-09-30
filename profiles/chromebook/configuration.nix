{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # use zsh
  users.defaultUserShell  = pkgs.zsh;
  programs.zsh.enable     = true;

  gab.login.sddm = true;

  gab.hardware = {
    bluetooth = true;
    pipewire  = true;

    i18n.locale     = "it_IT.UTF-8";
    keyboard.layout = "it";
    time.timeZone   = "Europe/Rome";
  };

  gab.apps = {
    ssh  = true;
    dbus = true;

    corectrl = true;

    direnv = true;
    docker = true;
  };

  gab.wm.hyprland = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  services.xserver.excludePackages = [ pkgs.xterm ];
}
