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
        localization,
        ...
      }:
      let
        cfg = config.gab.wm.hyprland;
      in
      {
        imports = [ inputs.hyprnix.homeModules.default ];

        options.gab.wm.hyprland = {
          enable = lib.mkEnableOption "hyprland";
          monitors = lib.mkOption {
            type = with lib.types; listOf attrs;
            default = [ ];
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = with pkgs; [
            wev
            wlr-randr
            wl-clipboard
          ];

          hyprnix = {
            enable = true;
            systemd.enable = true;
            xwayland.enable = true;

            settings = {
              env = {
                NIXOS_OZONE_WL = 1;
              };

              dwindle = {
                preserve_split = true;
                pseudotile = true;
              };

              scrolling = {
                follow_min_visible = 0.1;
              };

              monitors = cfg.monitors ++ [
                {
                  output = "";
                  mode = "preferred";
                  position = "auto";
                }
              ];

              workspaces =
                builtins.genList (i: i + 1) 3
                |> map (i: {
                  id = i;
                  rules.persistent = true;
                });

              misc = {
                force_default_wallpaper = 0;
              };

              animations = {
                bezier = {
                  easeInOutCubic = [
                    0.65
                    0
                    0.35
                    1
                  ];
                  easeOutCirc = [
                    0
                    0.55
                    0.45
                    1
                  ];

                  linear = [
                    0
                    0
                    1
                    1
                  ];
                };

                animations = [
                  {
                    name = "borderangle";
                    speed = 20;
                    curve = "linear";
                    style = "loop";
                  }
                  {
                    name = "fadeIn";
                    speed = 2;
                    curve = "easeOutCirc";
                  }
                  {
                    name = "fadeOut";
                    speed = 2;
                    curve = "easeOutCirc";
                  }
                  {
                    name = "windowsIn";
                    speed = 1;
                    curve = "easeOutCirc";
                    style = "popin 60%";
                  }
                  {
                    name = "windowsMove";
                    speed = 2;
                    curve = "easeInOutCubic";
                    style = "popin";
                  }
                  {
                    name = "windowsOut";
                    speed = 2;
                    curve = "easeOutCirc";
                    style = "popin 60%";
                  }
                  {
                    name = "workspaces";
                    speed = 2;
                    curve = "easeOutCirc";
                    style = "slidevert";
                  }
                ];
              };

              master = {
                new_status = "master";
              };

              general = {
                allow_tearing = false;
                border_size = 2;
                gaps_in = 5;
                gaps_out = 20;
                layout = "scrolling";
              };

              input = {
                touchpad.natural_scroll = false;
                follow_mouse = 1;
                kb_layout = localization.keyboard.layout;
                kb_variant = localization.keyboard.variant;
                numlock_by_default = true;
              };

              gesture.gestures = [
                {
                  action = "workspace";
                  direction = "vertical";
                  fingers = 3;
                }
                "3, left, dispatcher, movefocus, l"
                "3, right, dispatcher, movefocus, r"
              ];

              decoration = {
                rounding = 10;

                blur = {
                  enabled = true;
                  new_optimizations = true;
                  passes = 1;
                  size = 3;
                };

                shadow = {
                  enabled = true;
                  range = 4;
                  render_power = 3;
                };
              };

              group = {
                auto_group = true;

                groupbar = {
                  enabled = true;
                  blur = true;
                  font_size = 13;
                  indicator_height = 2;
                  rounding = 8;
                  rounding_power = 4;
                };
              };

              ecosystem = {
                no_donation_nag = true;
                no_update_news = true;
              };
            };
          };
        };
      };
  };
}
