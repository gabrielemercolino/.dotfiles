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
      {
        config,
        pkgs,
        loadTheme,
        ...
      }:
      let
        cfg = config.gab.wm.hyprland;
        theme = loadTheme { inherit config lib pkgs; };
        extras = theme.extras or { };
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

          programs = {
            kitty = {
              enable = true;
              settings = {
                confirm_os_window_close = 0;
                cursor_trail = 10;
              };
            };

            swaylock = {
              enable = true;
              settings = {
                package = pkgs.swaylock-effects;
                effect-blur = "7x5";
                effect-vignette = "0.7:0.7";
                indicator = true;
                clock = true;
              };
            };

            ags-bar = {
              enable = true;
              systemd.enable = true;

              fonts = [ "DejaVu Sans Mono" ];
              colors.base16 = theme.palette;

              commands.lock = "${pkgs.swaylock-effects}/bin/swaylock";
            };

            rofi = {
              enable = true;
              package = pkgs.rofi;
              theme = lib.mkMerge [
                (import ./_rofi-theme.nix { inherit config; })
                (extras.rofi or { })
              ];
              extraConfig = {
                modi = "drun";
                show-icons = true;
                icon-theme = "WhiteSur";
                display-drun = "run";
                drun-display-format = "{name}";
              };
            };
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
