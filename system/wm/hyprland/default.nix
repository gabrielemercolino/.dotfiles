{ pkgs, ... }:

{
	imports = [
    ../../services/wayland.nix
    ../../services/dbus.nix
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
