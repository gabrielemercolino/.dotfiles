{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
  ];

  gab = {
    hardware = {
      bluetooth.enable = true;
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
