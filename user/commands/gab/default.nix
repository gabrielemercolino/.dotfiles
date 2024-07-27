{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (callPackage ./gab.nix {})
  ];
}
