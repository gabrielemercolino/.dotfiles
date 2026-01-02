{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.graphics.extraPackages = [pkgs.libva];
  nixpkgs.config.rocmSupport = true;

  gab = {
    login.sddm.enable = true;

    hardware = {
      bluetooth.enable = true;
      pipewire.enable = true;
      #pulseaudio.enable = true;

      i18n.locale = "it_IT.UTF-8";
      keyboard.layout = "it";
      time = {
        timeZone = "Europe/Rome";
        hardware-clock.enable = true;
      };
    };

    apps = {
      ssh.enable = true;
      dbus.enable = true;

      corectrl.enable = true;
      lact.enable = true;
      bashmount.enable = true;

      direnv.enable = true;
      docker.enable = true;
    };

    style = {
      theme = "syntwave-soft";
    };

    gaming = {
      steam.enable = true;
      gamemode.enable = true;
      gamescope.enable = true;
      lsfg.enable = true;
      #rpcs3.enable = true;
      #suyu.enable = true;
    };

    wm.hyprland.enable = true;
    wm.bspwm.enable = false;
  };

  services.xserver.excludePackages = [pkgs.xterm];
}
