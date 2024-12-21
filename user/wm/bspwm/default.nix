{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./eww
  ];

  services.sxhkd = {
    enable = config.xsession.windowManager.bspwm.enable;
    keybindings =
      let
        groups = {
          launchApps = {
            "super + Return" = "${pkgs.kitty}/bin/kitty";
            "super + t" = "${pkgs.telegram-desktop}/bin/telegram-desktop";
            "super + space" = "${pkgs.rofi}/bin/rofi -show drun";
            "super + shift + h" = "${pkgs.kitty}/bin/kitty ${pkgs.btop}/bin/btop";
          };
          windowToggles = {
            "super + {shift + v,v,f}" = "bspc node -t {tiled,floating,fullscreen}";
          };
          audioControl = {
            "XF86AudioRaiseVolume" = "${pkgs.pamixer}/bin/pamixer -i 5";
            "XF86AudioLowerVolume" = "${pkgs.pamixer}/bin/pamixer -d 5";
            "XF86AudioMute" = "${pkgs.pamixer}/bin/pamixer -t";
          };
          brightnessControl = {
            "XF86MonBrightnessUp" = "${pkgs.brightnessctl}/bin/brightnessctl set +5%";
            "XF86MonBrightnessDown" = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
          };
          powerControl = {
            "super + shift + {p,r}" = "systemctl {poweroff, reboot}";
          };
          bar = {
            "super + w" = "pkill eww && eww open bar";
          };
          changeWorkspace = {
            "super + {1-5}" = "bspc desktop -f '^{1-5}'";
          };
          moveToWorkspace = {
            "super + shift + {1-5}" = "bspc node -d '^{1-5}'";
          };
        };
        screenRecord = (pkgs.callPackage ../../commands/screen-record { });
        screenShot = (pkgs.callPackage ../../commands/screen-shot { });
      in
      lib.mkMerge [
        groups.launchApps
        groups.windowToggles
        groups.audioControl
        groups.brightnessControl
        groups.powerControl
        groups.bar
        groups.changeWorkspace
        groups.moveToWorkspace
        {
          "super + shift + s" = "${screenRecord}/bin/screen-record";
          "super + ctrl + s" = "${screenShot}/bin/screen-shot";
        }
        {
          "super + q" = "bspc node -k";
          "super + m" = "bspc quit";
          "super + shift + m" = "bspc wm -r";
        }
      ];
  };

  services.picom = {
    enable = config.xsession.windowManager.bspwm.enable;
    vSync = true;
    settings = {
      experimental-backends = true;
      corner-radius = 16;
    };
    backend = "glx";
  };

  xsession.windowManager.bspwm = {
    startupPrograms = [
      "pkill -x sxhkd; sxhkd"

      "bspc monitor -d 1 2 3 4 5"

      "pkill picom; picom -b"

      "${pkgs.nitrogen}/bin/nitrogen --set-auto ${config.stylix.image}"

      "pkill eww; eww open bar"
    ];

    settings = {
      # window information
      border_width = 3;
      window_gap = 14;
      pointer_follows_monitor = true;
      focus_follows_pointer = true;
      borderless_monocle = true;
      gapless_monocle = true;
      #focused_border_color = "#302D41";
      #normal_border_color = "#1e1e28";
    };
  };
}
