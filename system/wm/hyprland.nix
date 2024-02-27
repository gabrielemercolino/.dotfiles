{ config, pkgs, ... }:

{
	imports = [
    ./wayland.nix
    ./dbus.nix
    ./pulseaudio.nix
  ];

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };
}