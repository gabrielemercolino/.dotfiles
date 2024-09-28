{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.gab.wm;
in
{
  imports = [ inputs.hyprland-nix.homeManagerModules.default ];

  options.gab.wm = {
    hyprland = lib.mkEnableOption "hyprland";
    bspwm    = lib.mkEnableOption "bspwm";
  };

  config = {
    wayland.windowManager.hyprland = {
      enable  = cfg.hyprland;
      package = pkgs.hyprland;

      reloadConfig           = true;
      systemdIntegration     = true;
      recommendedEnvironment = true;
      xwayland.enable        = true;
    };

    xsession.windowManager.bspwm.enable = cfg.bspwm;
  };
  
}
