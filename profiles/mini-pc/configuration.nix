{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
  ];

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
      lact.enable = true;
      bashmount.enable = true;

      direnv.enable = true;
      docker.enable = true;
    };

    gaming = {
      gamemode.enable = true;
      gamescope.enable = true;
      lsfg.enable = true;
      #rpcs3.enable = true;
      #suyu.enable = true;
    };
  };

}
