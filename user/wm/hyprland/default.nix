{
  config,
  lib,
  pkgs,
  systemSettings,
  ...
}: {
  imports = [
    ./waybar.nix
  ];

  home.packages = with pkgs; [
    wev
    wlr-randr
    wl-clipboard
  ];
  wayland.windowManager.hyprland = {
    keyBinds = let
      MOUSE_L = "mouse:272";
      MOUSE_R = "mouse:273";
      # collection of keybinds grouped by functionality
      groups = {
        launchApps = {
          bind = {
            "SUPER, RETURN" = "exec, ${pkgs.kitty}/bin/kitty";
            "SUPER, T" = "exec, ${pkgs.telegram-desktop}/bin/Telegram";
            "SUPER_SHIFT, H" = "exec, ${pkgs.kitty}/bin/kitty ${pkgs.btop}/bin/btop";
            "SUPER, SPACE" = "exec, ${pkgs.rofi}/bin/rofi -show drun";
          };
        };
        windowToggles = {
          bind = {
            "SUPER, V" = "togglefloating";
            "SUPER, F" = "fullscreen";
            "SUPER, P" = "pseudo";
            "SUPER, J" = "togglesplit";
          };
        };
        mouseWindowControl = {
          bindm = {
            "SUPER, ${MOUSE_L}" = "movewindow";
            "SUPER, ${MOUSE_R}" = "resizewindow";
          };
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
          bind."SUPER, W" = "exec, pkill waybar; ${pkgs.waybar}/bin/waybar";
        };
        moveFocus = {
          bind = {
            "SUPER, left" = "movefocus, l";
            "SUPER, right" = "movefocus, r";
            "SUPER, up" = "movefocus, u";
            "SUPER, down" = "movefocus, d";
          };
        };
        changeWorkspace = {
          bind = {
            "SUPER, 0" = "workspace, 0";
            "SUPER, 1" = "workspace, 1";
            "SUPER, 2" = "workspace, 2";
            "SUPER, 3" = "workspace, 3";
            "SUPER, 4" = "workspace, 4";
            "SUPER, 5" = "workspace, 5";
            "SUPER, 6" = "workspace, 6";
            "SUPER, 7" = "workspace, 7";
            "SUPER, 8" = "workspace, 8";
            "SUPER, 9" = "workspace, 9";
          };
        };
        moveToWorkspace = {
          bind = {
            "SUPER_SHIFT, 0" = "movetoworkspace, 0";
            "SUPER_SHIFT, 1" = "movetoworkspace, 1";
            "SUPER_SHIFT, 2" = "movetoworkspace, 2";
            "SUPER_SHIFT, 3" = "movetoworkspace, 3";
            "SUPER_SHIFT, 4" = "movetoworkspace, 4";
            "SUPER_SHIFT, 5" = "movetoworkspace, 5";
            "SUPER_SHIFT, 6" = "movetoworkspace, 6";
            "SUPER_SHIFT, 7" = "movetoworkspace, 7";
            "SUPER_SHIFT, 8" = "movetoworkspace, 8";
            "SUPER_SHIFT, 9" = "movetoworkspace, 9";
          };
        };
      };
      screenShot = pkgs.callPackage ../../commands/screen-shot {};
      screenRecord = pkgs.callPackage ../../commands/screen-record {};
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
          bind."SUPER CONTROL_L, S" = "exec, ${screenShot}/bin/screen-shot";
          bind."SUPER_SHIFT, S" = "exec, ${screenRecord}/bin/screen-record";
        }
      ];

    environment = {
      #"XCURSOR_SIZE" = 36;
      #"WLR_NO_HARDWARE_CURSORS" = 1;
      #"XCURSOR_THEME" = "Breeze";
    };

    config = {
      exec_once = [
        "${pkgs.waybar}/bin/waybar"
      ];
      exec = [
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

      gesture = [
        "3, swipe, workspace"
      ];

      misc = {
        force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
      };
    };

    animations.animation = {
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
  };
}
