{ config, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { pkgs, host, ... }:
    let
      screenShot = config.flake.packages.${host.system}.screen-shot;
      screenRecord = config.flake.packages.${host.system}.screen-record;

      MOUSE_L = "mouse:272";
      MOUSE_R = "mouse:273";
      terminal = "${lib.getExe pkgs.ghostty}";
      # collection of keybinds grouped by functionality
      groups = {
        launchApps = {
          "SUPER + RETURN".dispatcher.exec_cmd = terminal;
          "SUPER + T".dispatcher.exec_cmd = lib.getExe pkgs.telegram-desktop;
          "SUPER + SHIFT + H".dispatcher.exec_cmd = "${terminal} -e ${lib.getExe pkgs.btop-rocm}";
          "SUPER + SPACE".dispatcher.exec_cmd = "${lib.getExe pkgs.rofi} -show drun";
        };
        windowToggles = {
          "SUPER + Q".dispatcher.window.close = { };
          "SUPER + V".dispatcher.window.float.action = "toggle";
          "SUPER + F".dispatcher.window.fullscreen.mode = "fullscreen";
          "SUPER + M".dispatcher.window.fullscreen.mode = "maximized";
          "SUPER + P".dispatcher.window.pseudo.action = "toggle";
        };
        groupControl = {
          "SUPER + G".dispatcher.group.toggle = { };
          "SUPER + SHIFT + G".dispatcher.window.move.out_of_group = true;
          "SUPER + CONTROL + left".dispatcher.group.prev = { };
          "SUPER + CONTROL + right".dispatcher.group.next = { };
        };
        mouseWindowControl = {
          "SUPER + ${MOUSE_L}" = {
            dispatcher.window.drag = { };
            flags.mouse = true;
          };
          "SUPER + ${MOUSE_R}" = {
            dispatcher.window.resize = { };
            flags.mouse = true;
          };
        };
        audioControl = {
          "XF86AudioRaiseVolume" = {
            dispatcher.exec_cmd = "${lib.getExe pkgs.pamixer} -i 5";
            flags.repeating = true;
          };
          "XF86AudioLowerVolume" = {
            dispatcher.exec_cmd = "${lib.getExe pkgs.pamixer} -d 5";
            flags.repeating = true;
          };
          "XF86AudioMute".dispatcher.exec_cmd = "${lib.getExe pkgs.pamixer} -t";
        };
        brightnessControl = {
          "XF86MonBrightnessUp" = {
            dispatcher.exec_cmd = "${lib.getExe pkgs.brightnessctl} set +5%";
            flags.repeating = true;
          };
          "XF86MonBrightnessDown" = {
            dispatcher.exec_cmd = "${lib.getExe pkgs.brightnessctl} set 5%-";
            flags.repeating = true;
          };
        };
        powerControl = {
          "SUPER + SHIFT + R".dispatcher.exec_cmd = "systemctl reboot";
          "SUPER + SHIFT + P".dispatcher.exec_cmd = "systemctl poweroff";
        };
        moveFocus = {
          "SUPER + left".dispatcher.focus.direction = "left";
          "SUPER + right".dispatcher.focus.direction = "right";
          "SUPER + up".dispatcher.focus.direction = "up";
          "SUPER + down".dispatcher.focus.direction = "down";
        };
        changeWorkspace =
          builtins.genList (i: i + 1) 9
          |> (map (
            i:
            lib.nameValuePair "SUPER + ${toString i}" {
              dispatcher.focus.workspace = toString i;
            }
          ))
          |> builtins.listToAttrs;

        moveToWorkspace =
          builtins.genList (i: i + 1) 9
          |> (map (
            i:
            lib.nameValuePair "SUPER + SHIFT + ${toString i}" {
              dispatcher.window.move = {
                workspace = toString i;
                follow = true;
              };
            }
          ))
          |> builtins.listToAttrs;
      };
    in
    {
      hyprnix.settings.bind = lib.mkMerge [
        groups.powerControl
        groups.audioControl
        groups.brightnessControl
        groups.launchApps
        groups.changeWorkspace
        groups.moveToWorkspace
        groups.windowToggles
        groups.mouseWindowControl
        groups.groupControl
        groups.moveFocus
        {
          "SUPER + SHIFT + M".dispatcher.exit = { };
        }
        {
          "SUPER + CONTROL + S".dispatcher.exec_cmd = lib.getExe screenShot;
          "SUPER + SHIFT + S".dispatcher.exec_cmd = lib.getExe screenRecord;
        }
      ];
    };
}
