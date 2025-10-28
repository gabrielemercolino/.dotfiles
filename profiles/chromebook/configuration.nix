{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware = {
    graphics.extraPackages = with pkgs; [intel-media-driver];
  };

  gab = {
    login.sddm.enable = true;

    hardware = {
      bluetooth.enable = true;
      pipewire.enable = true;
      #pulseaudio.enable = true;

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

    style = {
      theme = "tokyo-night";
      fonts.sizes = {
        applications = 14;
        desktop = 12;
        popups = 12;
        terminal = 14;
      };
    };

    # to run visual paradigm
    gaming.steam.enable = true;

    wm.hyprland.enable = true;
    wm.bspwm.enable = false;
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
