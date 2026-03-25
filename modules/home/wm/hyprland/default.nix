{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.homeManager = {
    wm.imports = [ self.modules.homeManager.hyprland ];

    hyprland =
      { config, pkgs, ... }:
      let
        cfg = config.gab.wm.hyprland;
      in
      {
        imports = [
          ./_style.nix
          inputs.hyprnix.homeManagerModules.default
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
