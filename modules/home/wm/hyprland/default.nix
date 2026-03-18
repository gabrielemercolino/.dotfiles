{
  inputs,
  config,
  lib,
  ...
}:
{
  flake.modules.homeManager = {
    wm.imports = [ config.flake.modules.homeManager.hyprland ];

    hyprland =
      {
        config,
        pkgs,
        ...
      }:
      let
        cfg = config.gab.wm.hyprland;
      in
      {
        imports = [
          ./_style.nix
          inputs.hyprnix.homeManagerModules.default
          inputs.ags-bar.homeManagerModules.default
        ];

        options.gab.wm.hyprland = {
          enable = lib.mkEnableOption "hyprland";
          monitors = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = with pkgs; [
            wev
            wlr-randr
            wl-clipboard
          ];

          programs.ags-bar = {
            enable = true;
            systemd.enable = true;

            commands.lock = "${pkgs.swaylock-effects}/bin/swaylock";
          };

          wayland.windowManager.hyprland = {
            enable = true;
            package = pkgs.hyprland;

            reloadConfig = true;
            systemd.enable = true;
            recommendedEnvironment = true;
            xwayland.enable = true;

            environment = { };
          };
        };
      };
  };
}
