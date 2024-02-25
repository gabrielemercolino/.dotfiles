{ config, pkgs, systemSettings, ... }:

{
	environment.systemPackages = [ pkgs.wayland ];

  # Configure xwayland
  services.xserver = {
    layout = systemSettings.keyLayout;
    xkbVariant = "";
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}