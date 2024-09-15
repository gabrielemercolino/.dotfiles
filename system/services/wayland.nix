{ pkgs, systemSettings, ... }:

{
  imports = [
    ./sddm.nix
  ];

	environment.systemPackages = [ pkgs.wayland ];

  # Configure xwayland
  services = {
    xserver = {
      xkb = {
        variant = "";
        layout = systemSettings.kb.layout;
      };
      enable = true;
    };
  };
}
