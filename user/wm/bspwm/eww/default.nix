{ pkgs, ... }:
{
  home.packages = with pkgs; [
    pamixer
    wmctrl
  ];

  programs.eww = {
    enable = true;
    configDir = ./config;
  };
}
