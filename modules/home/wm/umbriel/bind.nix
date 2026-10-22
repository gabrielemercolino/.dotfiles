{ config, lib, ... }:
{
  flake.modules.homeManager.umbriel =
    { pkgs, host, ... }:
    let
      screenShot = config.flake.packages.${host.system}.screen-shot;
      screenRecord = config.flake.packages.${host.system}.screen-record;

      terminal = "${lib.getExe pkgs.ghostty}";

      # keybinds grouped by functionality, mirroring hyprland
      groups = {
        launchApps = {
          "Mod+Return" = "spawn:${terminal}";
          "Mod+T" = "spawn:${lib.getExe pkgs.telegram-desktop}";
          "Mod+Shift+H" = "spawn:${terminal} -e ${lib.getExe pkgs.btop-rocm}";
          "Mod+Space" = "spawn:${lib.getExe pkgs.rofi} -show drun";
        };

        windowToggles = {
          "Mod+Q" = "window-close";
          "Mod+V" = "window-toggle-floating";
          "Mod+F" = "window-toggle-fullscreen";
          "Mod+M" = "window-toggle-maximize-to-edges";
        };

        groupControl = {
          "Mod+G" = "column-toggle-tabbed";
          "Mod+Shift+G" = "window-consume-or-expel-right";
          "Mod+Ctrl+Left" = "column-focus-tab-previous";
          "Mod+Ctrl+Right" = "column-focus-tab-next";
        };

        audioControl = {
          "XF86AudioRaiseVolume" = "spawn:${lib.getExe pkgs.pamixer} -i 5";
          "XF86AudioLowerVolume" = "spawn:${lib.getExe pkgs.pamixer} -d 5";
          "XF86AudioMute" = {
            action = "spawn:${lib.getExe pkgs.pamixer} -t";
            repeat = false;
          };
        };

        brightnessControl = {
          "XF86MonBrightnessUp" = "spawn:${lib.getExe pkgs.brightnessctl} set +5%";
          "XF86MonBrightnessDown" = "spawn:${lib.getExe pkgs.brightnessctl} set 5%-";
        };

        powerControl = {
          "Mod+Shift+R" = "spawn:systemctl reboot";
          "Mod+Shift+P" = "spawn:systemctl poweroff";
          "Mod+Shift+O" = "spawn:systemctl sleep";
        };

        moveFocus = {
          "Mod+Left" = "window-focus-left";
          "Mod+Right" = "window-focus-right";
          "Mod+Up" = "window-focus-up";
          "Mod+Down" = "window-focus-down";
        };

        changeWorkspace =
          builtins.genList (i: i + 1) 9
          |> (map (i: lib.nameValuePair "Mod+${toString i}" "workspace-switch:${toString i}"))
          |> builtins.listToAttrs;

        moveToWorkspace =
          builtins.genList (i: i + 1) 9
          |> (map (i: lib.nameValuePair "Mod+Shift+${toString i}" "window-move-to-workspace:${toString i}"))
          |> builtins.listToAttrs;
      };
    in
    {
      programs.umbriel.settings.keybinds = lib.mkMerge [
        groups.powerControl
        groups.audioControl
        groups.brightnessControl
        groups.launchApps
        groups.changeWorkspace
        groups.moveToWorkspace
        groups.windowToggles
        groups.groupControl
        groups.moveFocus
        {
          "Mod+Shift+M" = "session-quit"; # hyprland exit
          "Mod+O" = "overview-toggle"; # umbriel-specific
        }
        {
          "Mod+Ctrl+S" = "spawn:${lib.getExe screenShot}";
          "Mod+Shift+S" = "spawn:${lib.getExe screenRecord}";
        }
      ];
    };
}
