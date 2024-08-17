{ config, pkgs, userSettings, ... }:

{
  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + Return" = "${userSettings.terminal}";
      "super + q" = "bspc node -k";
      "super + m" = "bspc quit";
      "super + shift + m" = "bspc wm -r && pkill -USR1 -x sxhkd";
      
      # apps
      "super + space" = "${pkgs.rofi}/bin/rofi -show drun";
      "super + shift + h" = "${pkgs.kitty}/bin/kitty ${pkgs.btop}/bin/btop";

      # navigation
      "super + {1-5}" = "bspc desktop -f '^{1-5}'";

      # move to workspace (and go to that workspace)
      "super + shift + {1-5}" = "bspc node -d '^{1-5}' && bspc desktop -f '^{1-5}'";

      # window managment
      "super + {shift + v,v,f}" = "bspc node -t {tiled,floating,fullscreen}";
    };
  };

  services.picom = {
    enable = true;
    vSync = true;
    settings = {
      experimental-backends = true; 
    };
    backend = "xr_glx_hybrid";
  };

  services.polybar = {
    enable = true;
    script = ''
      pkill polybar

      polybar main 2>&1 | tee -a /tmp/polybar_main.log & disown
    '';
    settings = {
      "bar/main" = {
        width = "100%";
        height = "24pt";
        radius = 6;

        modules-left = "cpu ram";
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 1;
        warn-percentage = 95;
      };
    };
  };

  xsession.windowManager.bspwm = { 
    enable = true;
    startupPrograms = [ 
      "pgrep -x sxhkd > /dev/null || sxhkd" 
      
      "bspc monitor -d 1 2 3 4 5"
      "pkill picom && picom -b"
      "${pkgs.nitrogen}/bin/nitrogen --set-auto ${config.stylix.image}"
    ];

    settings = {
      # window information
      border_width = 3;
      window_gap = 14;
      pointer_follows_monitor = true;
      focus_follows_pointer = true;
      borderless_monocle = true;
      gapless_monocle = true;
      focused_border_color = "#302D41";
      normal_border_color = "#1e1e28";
    };
  }; 
}
