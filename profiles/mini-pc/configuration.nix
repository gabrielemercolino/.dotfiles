{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./theme.nix

    ../base/configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  hardware.graphics.extraPackages = [pkgs.libva];
  nixpkgs.config.rocmSupport = true;
  networking.hostName = "mini-pc";

  gab = {
    login.sddm.enable = true;

    hardware = {
      bluetooth.enable = true;
      audio-server = "pipewire";

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

    gaming = {
      steam.enable = true;
      gamemode.enable = true;
      gamescope.enable = true;
      lsfg.enable = true;
      #rpcs3.enable = true;
      #suyu.enable = true;
    };

    wm.hyprland.enable = true;
  };

  services.xserver.excludePackages = [pkgs.xterm];
}
