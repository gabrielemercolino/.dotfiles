{ pkgs, ... }:

{
  imports = [
    ./sddm.nix
  ];

	environment.systemPackages = [ pkgs.wayland ];

  # Configure xwayland
  services.xserver.enable = true;
}
