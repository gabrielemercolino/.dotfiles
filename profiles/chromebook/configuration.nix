{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # use zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  gab.login.sddm.enable = true;

  gab.hardware = {
    bluetooth.enable = true;
    pipewire.enable = false;
    pulseaudio.enable = true;

    i18n.locale = "it_IT.UTF-8";
    keyboard.layout = "it";
    time.timeZone = "Europe/Rome";
  };

  gab.apps = {
    ssh.enable = true;
    dbus.enable = true;

    corectrl.enable = true;

    direnv.enable = true;
    docker.enable = true;
  };

  gab.wm.hyprland.enable = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  services.xserver.excludePackages = [ pkgs.xterm ];
}
