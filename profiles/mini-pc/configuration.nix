{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
  ];

  gab = {
    apps = {
      ssh.enable = true;
      dbus.enable = true;

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
