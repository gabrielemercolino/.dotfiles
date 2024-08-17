{ pkgs, ... }:

{
  imports = [
    ./x11.nix
    ./dbus.nix 
  ];

  services.xserver.windowManager.bspwm = {
    enable = true;
    package = pkgs.bspwm; 
  };
}
