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

    nix.settings = rec {
      substituters = ["https://hyprland.cachix.org"];
      trusted-substituters = substituters;
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
  };
}
