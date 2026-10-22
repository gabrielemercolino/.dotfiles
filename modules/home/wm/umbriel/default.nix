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
        imports = [ inputs.umbriel.homeModules.default ];

        options.gab.wm.umbriel = {
          enable = lib.mkEnableOption "umbriel";

          monitors = lib.mkOption {
            type = with lib.types; listOf attrs;
            default = [ ];
          };
        };

        config = lib.mkIf cfg.enable {
          programs.ghostty.enable = true;

          programs.umbriel = {
            enable = true;
            settings = {
              general = {
                autostart = [ "${lib.getExe pkgs.ghostty}" ];
                xwayland = true;
              };

              input.keyboard = {
                layout = localization.keyboard.layout;
                numlock_toggle = true;
              };

              input.focus.follows_mouse = true;

              layout = {
                mode = "scrolling";
                gap = 8;
                scrolling.default_extent_fraction = 0.5; # extent for windows that aren't alone
                tabs.default_display = "tabbed"; # closest to hyprland group.auto_group
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
                |> builtins.map (m: lib.nameValuePair m.output (builtins.removeAttrs m [ "output" ]))
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
