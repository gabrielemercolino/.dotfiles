{ inputs, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { config, pkgs, ... }:
    let
      cfg = config.gab.wm.hyprland;
    in
    {
      imports = [ inputs.ags-bar.homeManagerModules.default ];

      config = lib.mkIf cfg.enable {
        programs = {
          ghostty.enable = true;

          hyprlock = {
            enable = true;
            settings = {
              general = {
                disable_loading_bar = false;
                hide_cursor = true;
                grace = 0;
              };

              animations = {
                enabled = true;
                bezier = "linear, 1, 1, 0, 0";
                animation = [
                  "fadeIn, 1, 2, linear"
                  "fadeOut, 1, 2, linear"
                  "inputFieldDots, 1, 2, linear"
                ];
              };

              background = {
                blur_passes = 2;
                blur_size = 3;
                brightness = 0.5;
              };

              input-field = {
                monitor = "";
                size = "150, 40";
                outline_thickness = 2;
                fade_on_empty = false;
                rounding = 15;
                font_family = "$font";
                placeholder_text = "Password...";
                fail_text = "";
                dots_size = 0.4;
                dots_spacing = 0.3;
                position = "0, 80";
                halign = "center";
                valign = "bottom";
              };

              label = [
                {
                  text = "$USER";
                  font_family = "$font";
                  color = "$text";
                  position = "0, 160";
                  halign = "center";
                  valign = "bottom";
                }
                {
                  text = ''cmd[update:1] date +"%H:%M"'';
                  font_size = 120;
                  font_family = "$font";
                  color = "$text_alpha";
                  position = "0, -200";
                  halign = "center";
                  valign = "top";
                }
              ];
            };
          };

          ags-bar = {
            enable = true;
            systemd.enable = true;

            # fonts = [ "DejaVu Sans Mono" ];

            # commands.lock = "${lib.getExe pkgs.hyprlock}";
          };

          rofi = {
            enable = true;
            package = pkgs.rofi;
            theme = (import ./_rofi-theme.nix { inherit config; });
            extraConfig = {
              modi = "drun";
              show-icons = true;
              icon-theme = "WhiteSur";
              display-drun = "run";
              drun-display-format = "{name}";
            };
          };
        };
      };
    };
}
