{ self, lib, ... }:
{
  flake.modules.homeManager = {
    apps.imports = [ self.modules.homeManager.hyprlock ];

    hyprlock =
      { config, ... }:
      let
        cfg = config.gab.apps.hyprlock;
        colors = config.lib.stylix.colors.withHashtag;
      in
      {
        options.gab.apps.hyprlock = {
          enable = lib.mkEnableOption "hyprlock";
        };

        config = lib.mkIf cfg.enable {
          programs.hyprlock = {
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
                  color = colors.base05;
                  position = "0, 160";
                  halign = "center";
                  valign = "bottom";
                }
                {
                  text = ''cmd[update:1] date +"%H:%M"'';
                  font_size = 120;
                  font_family = "$font";
                  color = colors.base04;
                  position = "0, -200";
                  halign = "center";
                  valign = "top";
                }
              ];
            };
          };
        };
      };
  };
}
