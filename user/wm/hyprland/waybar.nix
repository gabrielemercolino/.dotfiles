{ config, pkgs, systemSettings, ... }:

let 
  colors = config.lib.stylix.colors;
in
{
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
          "format" = " {usage}%";
          "max-length" = 10;
        };

        tray = {
          "spacing" = 10;
        };

        clock = {
          "interval" = 1;
          "format" = "  {:%H:%M %p}";
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
        background-color: #${colors.base01};
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
        background-color: #${colors.base00};
        color: #${colors.base05};
      }

      #workspaces button.active {
        color: #${colors.base00};
        background-color: #${colors.base05};
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #${colors.base00};
        background-color: #${colors.base05};
      }

      #workspaces button.urgent {
        background-color: #${colors.base08};
      }

      #memory,
      #cpu,
      #custom-power,
      #battery,
      #backlight,
      #pulseaudio,
      #network,
      #clock,
      #idle_inhibitor,
      #tray {
        border-radius: 4px;
        margin: 6px 3px;
        padding: 6px 12px;
        background-color: #${colors.base00};
        color: #${colors.base01};
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
        background-color: #${colors.base09};
      }

      #battery {
        background-color: #${colors.base08};
      }

      @keyframes blink {
        to {
          background-color: #${colors.base08};
          color: #${colors.base01};
        }
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        background-color: #ff0048;
        color: #${colors.base01};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.charging {
        background-color: #${colors.base0B};
      }

      #backlight {
        background-color: #${colors.base09};
      }

      #pulseaudio {
        background-color: #${colors.base0A};
      }

      #network {
        background-color: #${colors.base0C};
        padding-right: 17px;
      }

      #clock,
      #idle_inhibitor {
        font-family: JetBrainsMono Nerd Font;
        background-color: #${colors.base0E};
      }

      #custom-power {
        background-color: #${colors.base0F};
      }


      tooltip {
        border-radius: 8px;
        padding: 15px;
        background-color: #${colors.base00};
      }

      tooltip label {
        padding: 5px;
        background-color: #${colors.base00};
      }
    '';
  };

}
