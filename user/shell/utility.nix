{ pkgs, ... }:

{
  home.packages = with pkg; [
    vim # TODO: move out
    wget
    curl
    gcc
    neofetch
    htop
  ];
}