{ pkgs, ... }:

{
  imports = [
    ./gimp.nix
    ./yazi.nix
    (import ./rofi.nix { inherit pkgs; wayland = true; })
  ];
}
