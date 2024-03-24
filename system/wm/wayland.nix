{ config, pkgs, systemSettings, ... }:

{
  imports = [
    ./pipewire.nix
    #./pulseaudio.nix
  ];

	environment.systemPackages = [ pkgs.wayland ];

  # Configure xwayland
  services.xserver = {
    xkb = {
      variant = "";
      layout = systemSettings.keyLayout;
    };
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
