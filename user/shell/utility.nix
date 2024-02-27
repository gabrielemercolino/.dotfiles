{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wget
    curl
    neofetch
    htop
    pavucontrol
  ];
}