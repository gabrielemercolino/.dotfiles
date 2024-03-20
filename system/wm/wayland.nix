{ config, pkgs, systemSettings, ... }:

{
  imports = [
    ./pipewire.nix
  ];

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
