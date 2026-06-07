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

          services.hypridle = {
            enable = true;
            settings = {
              general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
              };

              listener = [
                {
                  timeout = 5 * 60;
                  on-timeout = "loginctl lock-session";
                }
                {
                  timeout = 10 * 60;
                  on-timeout = ''hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })' '';
                  on-resume = ''hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })' '';
                }
                {
                  timeout = 30 * 60;
                  on-timeout = "systemctl suspend";
                }
              ];
            };
          };

          hyprnix = {
            enable = true;
            systemd.enable = true;

            extraConfig =
              # lua
              ''
                hl.on("hyprland.start", function()
                  hl.exec_cmd("${lib.getExe pkgs.hypridle}")
                end)
              '';

            settings = {
              xwayland.enabled = true;

              env = {
                NIXOS_OZONE_WL = 1;
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

              workspace_rule = {
                "1".persistent = true;
                "2".persistent = true;
                "3".persistent = true;
              };

              window_rule = {
                "inhibit_idle_when_fullscreen" = {
                  match.fullscreen = true;
                  idle_inhibit = "fullscreen";
                };
              };

              misc = {
                force_default_wallpaper = 0;
              };

              curve.bezier = {
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

              animation = {
                fadeIn = {
                  speed = 2;
                  bezier = "easeOutCirc";
                };
                fadeOut = {
                  speed = 2;
                  bezier = "easeOutCirc";
                };
                windowsIn = {
                  speed = 1;
                  bezier = "easeOutCirc";
                  style = "popin 60%";
                };
                windowsMove = {
                  speed = 2;
                  bezier = "easeInOutCubic";
                  style = "popin";
                };
                windowsOut = {
                  speed = 2;
                  bezier = "easeOutCirc";
                  style = "popin 60%";
                };
                workspaces = {
                  speed = 2;
                  bezier = "easeOutCirc";
                  style = "slidevert";
                };
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
