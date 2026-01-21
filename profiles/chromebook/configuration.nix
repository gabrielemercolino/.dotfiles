{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./theme.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    graphics.extraPackages = with pkgs; [intel-media-driver];
  };

  gab = {
    login.sddm.enable = true;

    hardware = {
      bluetooth.enable = true;
      audio-server = "pipewire";

      i18n.locale = "it_IT.UTF-8";
      keyboard.layout = "it";
      time.timeZone = "Europe/Rome";
    };

    apps = {
      ssh.enable = true;
      dbus.enable = true;

      corectrl.enable = true;
      bashmount.enable = true;

      direnv.enable = true;
      docker.enable = true;
    };

    # to run visual paradigm
    gaming.steam.enable = true;

    wm.hyprland.enable = true;
  };

  services.logind.settings.Login = {
    # don’t shutdown when power button is short-pressed
    HandlePowerKey = "ignore";
  };

  services.xserver = {
    excludePackages = [pkgs.xterm];
    displayManager.sessionCommands = "xrdb -merge <<< \"Xft.dpi: 120\"";
  };
}
