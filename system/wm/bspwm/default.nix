{ pkgs, ... }:

{
  imports = [
    ../../services/x11.nix
    ../../services/dbus.nix 
  ];

  services.xserver.windowManager.bspwm = {
    enable = true;
    package = pkgs.bspwm; 
  };
}
