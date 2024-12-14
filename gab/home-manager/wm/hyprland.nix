{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.gab.wm.hyprland;
in
{
  imports = [ inputs.hyprland-nix.homeManagerModules.default ];

  options.gab.wm.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    monitors = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;

      reloadConfig = true;
      systemdIntegration = true;
      recommendedEnvironment = true;
      xwayland.enable = true;

      config = {
        monitor = cfg.monitors ++ [ ", preferred, auto, 1" ]; # add the default config
      };
    };
  };
}
