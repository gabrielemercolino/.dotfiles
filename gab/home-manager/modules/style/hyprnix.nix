{
  lib,
  config,
  ...
}: let
  hypr = config.wayland.windowManager.hyprland.settings;
in {
  # fix: hyprnix deletes these but stylix still will try to use them
  options.wayland.windowManager.hyprland.settings = {
    decoration = lib.mkOption {default = {};};
    general = lib.mkOption {default = {};};
    group = lib.mkOption {default = {};};
    misc = lib.mkOption {default = {};};
  };

  config = lib.mkIf config.stylix.enable {
    # fix: disabling hyprpaper as not used but automatically enables
    # if background is set
    stylix.targets.hyprpaper.enable = lib.mkForce false;
    services.hyprpaper.enable = lib.mkForce false;

    wayland.windowManager.hyprland.config = {
      decoration.shadow.color = hypr.decoration.shadow.color;

      general = {
        active_border_color = hypr.general."col.active_border";
        inactive_border_color = hypr.general."col.inactive_border";
      };

      group = {
        inactive_border_color = hypr.group."col.border_inactive";
        active_border_color = hypr.group."col.border_active";
        locked_active_border_color = hypr.group."col.border_locked_active";

        groupbar = {
          text_color = hypr.group.groupbar.text_color;
          active_color = hypr.group.groupbar."col.active";
          inactive_color = hypr.group.groupbar."col.inactive";
        };
      };

      misc.background_color = hypr.misc.background_color;
    };
  };
}
