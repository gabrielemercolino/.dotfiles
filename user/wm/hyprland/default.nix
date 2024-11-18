{
  config,
  lib,
  pkgs,
  systemSettings,
  ...
}:

{
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    wev
    wlr-randr
    wl-clipboard

    hyprpanel
  ];

  wayland.windowManager.hyprland.keyBinds =
    let
      MOUSE_L = "mouse:272";
      MOUSE_R = "mouse:273";
      # collection of keybinds grouped by functionality
      groups = {
        launchApps = {
          bind."SUPER, RETURN" = "exec, ${pkgs.kitty}/bin/kitty";
          bind."SUPER, T" = "exec, ${pkgs.telegram-desktop}/bin/telegram-desktop";
          bind."SUPER_SHIFT, H" = "exec, ${pkgs.kitty}/bin/kitty ${pkgs.btop}/bin/btop";
          bind."SUPER, SPACE" = "exec, ${pkgs.rofi-wayland}/bin/rofi -show drun";
        };
        windowToggles = {
          bind."SUPER, V" = "togglefloating";
          bind."SUPER, F" = "fullscreen";
          bind."SUPER, P" = "pseudo";
          bind."SUPER, J" = "togglesplit";
        };
        mouseWindowControl = {
          bindm."SUPER, ${MOUSE_L}" = "movewindow";
          bindm."SUPER, ${MOUSE_R}" = "resizewindow";
        };
        audioControl = {
          binde.", XF86AudioRaiseVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -i 5";
          binde.", XF86AudioLowerVolume" = "exec, ${pkgs.pamixer}/bin/pamixer -d 5";
          bind.", XF86AudioMute" = "exec, ${pkgs.pamixer}/bin/pamixer -t";
        };
        brightnessControl = {
          binde.", XF86MonBrightnessUp" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%";
          binde.", XF86MonBrightnessDown" = "exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        };
        powerControl = {
          bind."SUPER_SHIFT, R" = "exec, systemctl reboot";
          bind."SUPER_SHIFT, P" = "exec, systemctl poweroff";
        };
        bar = {
          #bind."SUPER, W" = "exec, pkill waybar || true && ${pkgs.waybar}/bin/waybar";
          bind."SUPER, W" = "exec, pkill ags || true && ${pkgs.hyprpanel}/bin/hyprpanel";
        };
        moveFocus = {
          bind."SUPER, left" = "movefocus, l";
          bind."SUPER, right" = "movefocus, r";
          bind."SUPER, up" = "movefocus, u";
          bind."SUPER, down" = "movefocus, d";
        };
        changeWorkspace = {
          bind."SUPER, 0" = "workspace, 0";
          bind."SUPER, 1" = "workspace, 1";
          bind."SUPER, 2" = "workspace, 2";
          bind."SUPER, 3" = "workspace, 3";
          bind."SUPER, 4" = "workspace, 4";
          bind."SUPER, 5" = "workspace, 5";
          bind."SUPER, 6" = "workspace, 6";
          bind."SUPER, 7" = "workspace, 7";
          bind."SUPER, 8" = "workspace, 8";
          bind."SUPER, 9" = "workspace, 9";
        };
        moveToWorkspace = {
          bind."SUPER_SHIFT, 0" = "movetoworkspace, 0";
          bind."SUPER_SHIFT, 1" = "movetoworkspace, 1";
          bind."SUPER_SHIFT, 2" = "movetoworkspace, 2";
          bind."SUPER_SHIFT, 3" = "movetoworkspace, 3";
          bind."SUPER_SHIFT, 4" = "movetoworkspace, 4";
          bind."SUPER_SHIFT, 5" = "movetoworkspace, 5";
          bind."SUPER_SHIFT, 6" = "movetoworkspace, 6";
          bind."SUPER_SHIFT, 7" = "movetoworkspace, 7";
          bind."SUPER_SHIFT, 8" = "movetoworkspace, 8";
          bind."SUPER_SHIFT, 9" = "movetoworkspace, 9";
        };
      };
      screenshot = "file_name=~/Pictures/screenshot_$(date +%Y-%m-%d-%T).png && ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" $file_name && wl-copy < $file_name";
      screenrec = "pkill wl-screenrec || ${pkgs.wl-screenrec}/bin/wl-screenrec --audio -b \"1 MB\"";
    in
    lib.mkMerge [
      groups.powerControl
      groups.launchApps
      groups.audioControl
      groups.brightnessControl
      groups.mouseWindowControl
      groups.windowToggles
      groups.bar
      groups.moveFocus
      groups.changeWorkspace
      groups.moveToWorkspace
      {
        bind."SUPER, Q" = "killactive";
        bind."SUPER, M" = "exit";
      }
      {
        bind."SUPER CONTROL_L, S" = "exec, ${screenshot}";
        bind."SUPER_SHIFT, S" = "exec, ${screenrec}";
      }
    ];

  wayland.windowManager.hyprland.config = {
    exec_once = [
      "${pkgs.hyprpanel}/bin/hyprpanel"
    ];
    exec = [
      #"$(pkill waybar || true) && ${pkgs.waybar}/bin/waybar"
      "${pkgs.swaybg}/bin/swaybg -m fill -i ${config.stylix.image}"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      layout = "dwindle";
      allow_tearing = false;
    };

    decoration = {
      rounding = 10;
      blur = {
        enabled = true;
        size = 3;
        passes = 1;
      };
      shadow = {
        enabled = true;
        range = 4;
        render_power = 3;
      };
    };

    input = {
      kb_layout = systemSettings.kb.layout;
      kb_variant = systemSettings.kb.variant;
      follow_mouse = 1;
      touchpad.natural_scroll = "no";
    };

    dwindle = {
      pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section
      preserve_split = "yes"; # you probably want this
    };

    master = {
      new_status = "master";
    };

    gestures = {
      workspace_swipe = "on";
    };

    misc = {
      force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
    };
  };

  wayland.windowManager.hyprland.animations.animation = {
    windowsIn = {
      enable = true;
      duration = 100;
      curve = "easeOutCirc";
      style = "popin 60%";
    };
    fadeIn = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
    };
    # window destruction
    windowsOut = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
      style = "popin 60%";
    };
    fadeOut = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
    };
    # window movement
    windowsMove = {
      enable = true;
      duration = 200;
      curve = "easeInOutCubic";
      style = "popin";
    };
    workspaces = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
      style = "slide";
    };
  };
}
