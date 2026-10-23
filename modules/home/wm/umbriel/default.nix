{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos = {
    hm.imports = [ self.modules.nixos.umbriel-hm ];

    umbriel-hm =
      {
        config,
        user,
        pkgs,
        ...
      }:
      let
        cfg = config.home-manager.users.${user.name}.gab.wm.umbriel or { enable = false; };
      in
      {
        imports = [ inputs.umbriel.nixosModules.default ];

        config = lib.mkIf cfg.enable {
          programs.umbriel.enable = true;

          # umbriel starts Xwayland on demand; the binary must be on PATH
          environment.systemPackages = [ pkgs.xwayland ];
        };
      };
  };

  flake.modules.homeManager = {
    wm.imports = [ self.modules.homeManager.umbriel ];

    umbriel =
      {
        config,
        pkgs,
        localization,
        ...
      }:
      let
        cfg = config.gab.wm.umbriel;

        mkLidEvent =
          action:
          cfg.monitors
          |> builtins.map (m: "umbriel msg ${action}:${m.output}")
          |> lib.concatStringsSep " && ";
      in
      {
        imports = [
          inputs.umbriel.homeModules.default
          self.modules.homeManager.rofi
          self.modules.homeManager.hyprlock
          self.modules.homeManager.hypridle
        ];

        options.gab.wm.umbriel = {
          enable = lib.mkEnableOption "umbriel";

          monitors = lib.mkOption {
            type = with lib.types; listOf attrs;
            default = [ ];
          };
        };

        config = lib.mkIf cfg.enable {
          gab.apps.rofi.enable = true;
          gab.apps.hyprlock.enable = true;
          gab.services.hypridle.enable = true;

          home.packages = with pkgs; [
            wl-clipboard
          ];

          programs.ghostty.enable = true;

          programs.umbriel = {
            enable = true;
            settings = {
              general = {
                autostart = [ "${lib.getExe pkgs.ghostty}" ];
                xwayland = true;
              };

              environment = {
                NIXOS_OZONE_WL = "1";
              };

              input.keyboard = {
                layout = localization.keyboard.layout;
                variant = localization.keyboard.variant;
                numlock_toggle = true;
              };

              input.touchpad = {
                natural_scroll = false;
              };

              input.focus.follows_mouse = true;

              layout = {
                mode = "scrolling";
                gap = 8;
                scrolling.default_extent_fraction = 0.5; # extent for windows that aren't alone
                tabs.default_display = "tabbed"; # closest to hyprland group.auto_group
              };

              animation = {
                enabled = true;

                beziers = {
                  easeOutCirc = [ 0.0 0.55 0.45 1.0 ];
                  easeInOutCubic = [ 0.65 0.0 0.35 1.0 ];
                };

                windows_in = {
                  curve = "easeOutCirc";
                  style = "popin";
                  scale = 0.6;
                };

                windows_out = {
                  curve = "easeOutCirc";
                  style = "popin";
                  scale = 0.6;
                };

                windows_move = {
                  curve = "easeInOutCubic";
                };

                windows_resize = {
                  curve = "easeInOutCubic";
                };

                workspaces = {
                  curve = "easeOutCirc";
                  style = "slide";
                };

                # Instant focus-border switch; the default spring reads as a flash
                # when toggling between windows in a tab group.
                border = {
                  enabled = false;
                };
              };

              # first (only) tiled window is full width; later windows are 0.5
              # and the previous one shrinks back to 0.5
              window_rule = [
                {
                  match.is_alone = true;
                  default_scrolling_extent = 1.0;
                }
              ];

              appearance = {
                border_width = 2;
                corner_radius = 10;
                blur.radius = 3;
                shadow.enabled = true;

                tab_bar = {
                  style = "titles";
                  height = 24;
                  font = "sans 13"; # ~ hyprland groupbar.font_size
                  corner_radius = 8; # ~ hyprland groupbar.rounding
                  visible = true; # ~ hyprland groupbar.enabled
                  hide_when_single = true;
                };
              };

              output =
                cfg.monitors
                |> builtins.map (
                  m:
                  lib.nameValuePair m.output (
                    (builtins.removeAttrs m [ "output" ]) // { min_workspaces = 3; }
                  )
                )
                |> builtins.listToAttrs;

              events = {
                lid_close = mkLidEvent "output-disable";
                lid_open = mkLidEvent "output-enable";
              };
            };
          };
        };
      };
  };
}
