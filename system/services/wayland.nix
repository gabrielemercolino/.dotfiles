{ pkgs, systemSettings, ... }:

{
  imports = [
    ./pipewire.nix
    ./sddm.nix
  ];

	environment.systemPackages = [ pkgs.wayland ];

  # Configure xwayland
  services = {
    xserver = {
      xkb = {
        variant = "";
        layout = systemSettings.keyLayout;
      };
      enable = true;
    };
  };
}
