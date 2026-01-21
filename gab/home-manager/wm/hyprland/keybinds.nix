{
  lib,
  pkgs,
  bar,
  kill-bar,
  ...
}: let
  screenShot = pkgs.callPackage ../../../cli/screen-shot {};
  screenRecord = pkgs.callPackage ../../../cli/screen-record {};

  MOUSE_L = "mouse:272";
  MOUSE_R = "mouse:273";
  terminal = "${lib.getExe pkgs.kitty}";
  # collection of keybinds grouped by functionality
  groups = {
    launchApps = {
      bind = {
        "SUPER, RETURN" = "exec, ${terminal}";
        "SUPER, T" = "exec, ${lib.getExe pkgs.telegram-desktop}";
        "SUPER_SHIFT, H" = "exec, ${terminal} -e ${lib.getExe pkgs.btop}";
        "SUPER, SPACE" = "exec, ${lib.getExe pkgs.rofi} -show drun";
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
    groupControl = {
      bind = {
        "SUPER, G" = "togglegroup";
        "SUPER_SHIFT, G" = "moveoutofgroup";
        "SUPER_CONTROL, left" = "changegroupactive, b";
        "SUPER_CONTROL, right" = "changegroupactive, f";
      };
    };
    mouseWindowControl = {
      bindm = {
        "SUPER, ${MOUSE_L}" = "movewindow";
        "SUPER, ${MOUSE_R}" = "resizewindow";
      };
    };
    audioControl = {
      binde.", XF86AudioRaiseVolume" = "exec, ${lib.getExe pkgs.pamixer} -i 5";
      binde.", XF86AudioLowerVolume" = "exec, ${lib.getExe pkgs.pamixer} -d 5";
      bind.", XF86AudioMute" = "exec, ${lib.getExe pkgs.pamixer} -t";
    };
    brightnessControl = {
      binde.", XF86MonBrightnessUp" = "exec, ${lib.getExe pkgs.brightnessctl} set +5%";
      binde.", XF86MonBrightnessDown" = "exec, ${lib.getExe pkgs.brightnessctl} set 5%-";
    };
    powerControl = {
      bind."SUPER_SHIFT, R" = "exec, systemctl reboot";
      bind."SUPER_SHIFT, P" = "exec, systemctl poweroff";
    };
    bar = {
      bind."SUPER, W" = "exec, ${kill-bar}; ${lib.getExe bar}";
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
      bind =
        builtins.genList (i: i) 10
        |> map (i: {
          name = "SUPER, ${toString i}";
          value = "workspace, ${toString i}";
        })
        |> builtins.listToAttrs;
    };
    moveToWorkspace = {
      bind =
        builtins.genList (i: i) 10
        |> map (i: {
          name = "SUPER_SHIFT, ${toString i}";
          value = "movetoworkspace, ${toString i}";
        })
        |> builtins.listToAttrs;
    };
  };
in
  lib.mkMerge [
    groups.powerControl
    groups.launchApps
    groups.audioControl
    groups.brightnessControl
    groups.mouseWindowControl
    groups.windowToggles
    groups.groupControl
    groups.bar
    groups.moveFocus
    groups.changeWorkspace
    groups.moveToWorkspace
    {
      bind."SUPER, Q" = "killactive";
      bind."SUPER_SHIFT, M" = "exit";
    }
    {
      bind."SUPER CONTROL_L, S" = "exec, ${lib.getExe screenShot}";
      bind."SUPER_SHIFT, S" = "exec, ${lib.getExe screenRecord}";
    }
  ]
