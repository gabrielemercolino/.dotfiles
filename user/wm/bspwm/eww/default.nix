{ pkgs, ... }:

let
  deps = with pkgs; [
    brightnessctl
    pamixer
    wmctrl
  ];

  eww-wrapper = pkgs.writeShellApplication {
    name = "eww";
    runtimeInputs = deps;
    text = ''
      exec ${pkgs.eww}/bin/eww "$@" 
    '';
  };
in
{
  programs.eww = {
    enable = true;
    package = eww-wrapper;
    configDir = ./config;
  };
}
