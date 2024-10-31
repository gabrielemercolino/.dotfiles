{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.gab.wm;
in
{
  imports = [ inputs.hyprland-nix.homeManagerModules.default ];

  options.gab.wm = {
    hyprland = {
      enable = lib.mkEnableOption "hyprland";
      monitors = lib.mkOption {
        type = with lib.types; listOf str;
        default = [ ];
      };
    };
    bspwm.enable = lib.mkEnableOption "bspwm";
  };

  config = {
    wayland.windowManager.hyprland = {
      enable = cfg.hyprland.enable;
      package = pkgs.hyprland;

      reloadConfig = true;
      systemdIntegration = true;
      recommendedEnvironment = true;
      xwayland.enable = true;

      config = {
        monitor = cfg.hyprland.monitors ++ [ ", preferred, auto, 1" ]; # add the default config
      };
    };

    xsession.windowManager.bspwm.enable = cfg.bspwm.enable;

  };

}
