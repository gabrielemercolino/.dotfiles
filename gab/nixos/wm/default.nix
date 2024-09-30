{ config, lib, pkgs, ... }:

let
  cfg = config.gab.wm;
in
{
  options.gab.wm = {
    bspwm.enable    = lib.mkEnableOption "bspwm";
    hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = {
    services.xserver.windowManager.bspwm = {
      enable  = cfg.bspwm.enable;
      package = pkgs.bspwm; 
    };

    programs.hyprland = {
      enable          = cfg.hyprland.enable;
      xwayland.enable = true;
      portalPackage   = pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
