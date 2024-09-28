{ config, lib, pkgs, ... }:

let
  cfg = config.gab.wm;
in
{
  options.gab.wm = {
    bspwm    = lib.mkEnableOption "bspwm";
    hyprland = lib.mkEnableOption "hyprland";
  };

  config = {
    services.xserver.windowManager.bspwm = {
      enable  = cfg.bspwm;
      package = pkgs.bspwm; 
    };

    programs.hyprland = {
      enable          = cfg.hyprland;
      xwayland.enable = true;
      portalPackage   = pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
