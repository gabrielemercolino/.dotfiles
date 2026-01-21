{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.wm;
in {
  options.gab.wm = {
    hyprland.enable = lib.mkEnableOption "hyprland";
  };

  config = {
    programs.hyprland = {
      enable = cfg.hyprland.enable;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
