{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    pamixer
    wmctrl
  ];

  programs.eww = {
    enable = true;
    configDir = ./config;
  };
}
