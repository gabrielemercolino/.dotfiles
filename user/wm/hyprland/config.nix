{ config, pkgs, userSettings, systemSettings, ... }:

{
  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;		

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
    # Whether to enable patching wlroots for better Nvidia support
    enableNvidiaPatches = true;
  };

  home.packages = with pkgs; [
    hyprland-protocols

    wtype
    wev
    wlr-randr
    wl-clipboard

    libva-utils

    libsForQt5.qt5.qtwayland
    qt6.qtwayland

    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
  
  # config from https://github.com/sameemul-haque/dotfiles
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 0;

        modules-left = [
          "custom/os"
          "hyprland/workspaces"
        ];
        modules-center = [ 
          "clock" 
        ];
        modules-right = [ 
          "tray"
          "cpu"
          "memory"
          "network"
          "pulseaudio"
          "battery"
          "idle_inhibitor"
          "custom/power"
          ];

        "custom/os" = {
          "format" = "   ";
          "tooltip" = false;
          "on-click" = "${pkgs.rofi}/bin/rofi -show drun";
        };
        
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            active = "󰪥";
            urgent = "󰪥";
          };
          "on-click" = "activate";
          "persistent-workspaces" = {
            "1" = [];
            "2" = [];
            "3" = [];
            "4" = [];
            "5" = [];
          };
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };

        memory = {
          "interval" = 5;
          "format" = "󰍛 {}%";
          "max-length" = 10;
        };
        
        cpu = {
          "interval" = 5;
          "format" = " {}%";
          "max-length" = 10;
        };

        tray = {
          "spacing" = 10;
        };

        clock = {
          "interval" = 1;
          "format" = "  {:%I:%M %p}";
          "timezone" = "${systemSettings.timeZone}";
          "tooltip-format" = ''<tt>{calendar}</tt>'';
        };

        network = {
          "format-wifi" = "{icon}";
          "format-icons" = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          "format-ethernet" = "󰀂";
	        "format-alt" = "󱛇";
          "format-disconnected" = "󰖪";
	        "tooltip-format-wifi" = "{icon} {essid}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
          "tooltip-format-ethernet" = "󰀂  {ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}";
	        "tooltip-format-disconnected" = "Disconnected";
	        #"on-click": "~/.config/rofi/wifi/wifi.sh &",
          #"on-click-right": "~/.config/rofi/wifi/wifinew.sh &",
	        "interval" = 5;
	        "nospacing" = 1;
        };

        pulseaudio = {
          "scroll-step" = 1;
          "nospacing" = 1;
          "tooltip-format" = "Volume : {volume}%";
          "format" = "{icon}";
          "format-bluetooth" = "";
          "format-muted" = "󰸈";
          "format-source" = "{volume}% ";
          "format-source-muted" = " ";
          "format-icons" = {
            "headphone" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "pavucontrol";
        };

        battery = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-icons" = {
            "charging" = [ "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅" ];
            "default" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          };
          "format-full" = "Charged ";
          "tooltip" = false;
        };

                
        "custom/power" = {
          "format" = "󰤆";
          "tooltip" = false;
          # "on-click" = "~/.config/rofi/powermenu/type-2/powermenu.sh &";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: Material Design Icons, JetBrainsMono Nerd Font;
        font-size: 13px;
      }

      window#waybar {
        background-color: #181825;
        transition-property: background-color;
        transition-duration: 0.5s;
      }
      
      window#waybar.hidden {
        opacity: 0.5;
      }

      #workspaces {
        background-color: transparent;
      } 

      #workspaces button {
        all: initial; /* Remove GTK theme values (waybar #1351) */
        min-width: 0; /* Fix weird spacing in materia (waybar #450) */
        box-shadow: inset 0 -3px transparent; /* Use box-shadow instead of border so the text isn't offset */
        padding: 6px 18px;
        margin: 6px 3px;
        border-radius: 4px;
        background-color: #1e1e2e;
        color: #cdd6f4;
      }

      #workspaces button.active {
        color: #1e1e2e;
        background-color: #cdd6f4;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #1e1e2e;
        background-color: #cdd6f4;
      }

      #workspaces button.urgent {
        background-color: #f38ba8;
      }

      #memory,
      #cpu,
      #custom-power,
      #battery,
      #backlight,
      #pulseaudio,
      #network,
      #clock,
      #tray {
        border-radius: 4px;
        margin: 6px 3px;
        padding: 6px 12px;
        background-color: #1e1e2e;
        color: #181825;
      }

      #custom-power {
        margin-right: 6px;
      }

      #custom-os {
        padding-right: 7px;
        padding-left: 7px;
        margin-left: 5px;
        font-size: 15px;
        border-radius: 8px 0px 0px 8px;
        color: #1793d1;
      }

      #memory,
      #cpu {
        background-color: #fab387;
      }

      #battery {
        background-color: #f38ba8;
      }

      @keyframes blink {
        to {
          background-color: #f38ba8;
          color: #181825;
        }
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        background-color: #ff0048;
        color: #181825;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.charging {
        background-color: #a6e3a1;
      }

      #backlight {
        background-color: #fab387;
      }

      #pulseaudio {
        background-color: #f9e2af;
      }

      #network {
        background-color: #94e2d5;
        padding-right: 17px;
      }

      #clock {
        font-family: JetBrainsMono Nerd Font;
        background-color: #cba6f7;
      }

      #custom-power {
        background-color: #f2cdcd;
      }


      tooltip {
        border-radius: 8px;
        padding: 15px;
        background-color: #131822;
      }

      tooltip label {
        padding: 5px;
        background-color: #131822;
      }
    '';
  };

  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$terminal" = userSettings.terminal;
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    bind = [
      "$mainMod, RETURN, exec, $terminal"
      "$mainMod, Q, killactive," 
      "$mainMod, M, exit, "
      "$mainMod, E, exec, dolphin"
      "$mainMod, V, togglefloating, "
      "$mainMod, R, exec, ${pkgs.rofi}/bin/rofi -show drun"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit,"
      "$mainMod, W, exec, pkill .waybar-wrapped && ${pkgs.waybar}/bin/waybar"

      # Override power-off and reboot commands
      "$mainMod SHIFT, R, exec, systemctl reboot"
      "$mainMod SHIFT, P, exec, systemctl poweroff"

      "$mainMod SHIFT, B, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
      "$mainMod SHIFT, N, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
      " , XF86PowerOff, exec, "

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
          "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ])
        10)
      );
    };

  wayland.windowManager.hyprland.extraConfig = ''
# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,highres,auto,1

# Some default env vars.
env = XCURSOR_SIZE,24

exec-once = ${pkgs.waybar}/bin/waybar

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    
    blur {
        enabled = true
        size = 3
        passes = 1
    }

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = ${systemSettings.keyLayout}
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = on
}

misc {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    force_default_wallpaper = 0 # Set to 0 to disable the anime mascot wallpapers
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    '';
}
