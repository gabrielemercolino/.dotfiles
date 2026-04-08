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
        imports = [ inputs.hyprnix.homeModules.default ];

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

          hyprnix = {
            enable = true;
            systemd.enable = true;
            xwayland.enable = true;

            settings = {
              dwindle = {
                preserve_split = true;
                pseudotile = true;
              };

              monitors = [
                {
                  output = "HDMI-A-1";
                  mode = "1920x1080@100";
                  position = "auto";
                }
                {
                  output = "DP-1";
                  mode = "1920x1080@100";
                  position = "auto";
                }
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
                beziers = [
                  {
                    name = "easeInOutCubic";
                    points = [
                      0.65
                      0
                      0.35
                      1
                    ];
                  }
                  {
                    name = "easeOutCirc";
                    points = [
                      0
                      0.55
                      0.45
                      1
                    ];
                  }
                  {
                    name = "linear";
                    points = [
                      0
                      0
                      1
                      1
                    ];
                  }
                ];

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
            };

            extraConfig =
              #conf
              ''
                env = NIXOS_OZONE_WL,1

                exec-once = systemctl --user stop hyprland-session.target
                exec-once = systemctl --user start hyprland-session.target

                master {
                    new_status = master
                }

                general {
                    allow_tearing = false
                    border_size = 2
                    gaps_in = 5
                    gaps_out = 20
                    layout = dwindle
                }

                input {
                    touchpad {
                        natural_scroll = false
                    }

                    follow_mouse = 1
                    kb_layout = it
                    kb_variant = 
                    numlock_by_default = true
                }

                group {
                    groupbar {
                        blur = true
                        font_size = 13
                        gradients = false
                        indicator_height = 2
                        rounding = 8
                        rounding_power = 4.000000
                    }

                    auto_group = true
                }

                decoration {
                    rounding = 10

                    blur {
                        enabled = true
                        passes = 1
                        size = 3
                    }

                    shadow {
                        color = rgba(1a0a0a99)
                        enabled = true
                        range = 4
                        render_power = 3
                    }
                }


                ecosystem {
                    no_donation_nag = true
                    no_update_news = true
                }

                gesture = 3, vertical, workspace
              '';
          };
        };
      };
  };
}
