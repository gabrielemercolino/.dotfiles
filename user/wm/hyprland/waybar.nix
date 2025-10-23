{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix) colors;
  timezone =
    pkgs.runCommand "timezone" {} ''echo $(timedatectl show --property=Timezone --value) > $out'';
in {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "pulseaudio"
          "network"
          "battery"
          "custom/power"
        ];

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

        clock = {
          "interval" = 1;
          "format" = "  {:%H:%M}";
          "timezone" = "${timezone}";
          "tooltip-format" = ''<tt>{calendar}</tt>'';
        };

        tray = {
          "spacing" = 10;
        };

        cpu = {
          "interval" = 5;
          "format" = " {icon}";
          "format-icons" = ["╸    " "━╸   " "━━╸  " "━━━╸ " "━━━━╸" "━━━━━"];
        };

        memory = {
          "interval" = 5;
          "format" = " {icon}";
          "format-icons" = ["╸    " "━╸   " "━━╸  " "━━━╸ " "━━━━╸" "━━━━━"];
        };

        pulseaudio = {
          "tooltip-format" = "Volume : {volume}%";
          "format" = "{icon}";
          "format-muted" = "       ";
          "format-icons" = {
            "default" = [
              "     "
              " ╸   "
              " ━╸  "
              " ━━╸ "
              " ━━━╸"
              " ━━━━"
            ];
          };
          "on-click" = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        network = {
          "format-wifi" = "{icon}";
          "format-icons" = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          "format-ethernet" = "󰀂";
          "format-alt" = "󱛇";
          "format-disconnected" = "󰖪";
          "tooltip-format-wifi" = "{icon} {essid}\n {bandwidthDownBytes}   {bandwidthUpBytes}";
          "tooltip-format-ethernet" = "󰀂  {ifname}\n {bandwidthDownBytes}   {bandwidthUpBytes}";
          "tooltip-format-disconnected" = "Disconnected";
          "interval" = 5;
          "nospacing" = 1;
        };

        battery = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-icons" = {
            "charging" = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            "default" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };
          "format-full" = "Charged ";
          "tooltip" = false;
        };

        "custom/power" = {
          "format" = "󰤆";
          "tooltip" = false;
          "on-click" = "${pkgs.swaylock-effects}/bin/swaylock";
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: JetBrainsMono Nerd Font;
        font-size: 13px;
      }

      window#waybar {
        background-color: transparent;
      }

      window#waybar.hidden {
        opacity: 0.5;
      }

      #workspaces {
        background-color: transparent;
      }

      #workspaces button {
        min-width: 0; /* Fix weird spacing in materia (waybar #450) */
        box-shadow: inset 0 -3px transparent; /* Use box-shadow instead of border so the text isn't offset */
        padding: 6px 16px;
        margin: 6px 3px;
        border-radius: 4px;
        background-color: #${colors.base01};
        color: #${colors.base05};
      }

      #workspaces button.active {
        color: #${colors.base01};
        background-color: #${colors.base05};
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #${colors.base01};
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
        background-color: #${colors.base01};
      }

      #custom-power {
        margin-right: 6px;
      }

      #memory,
      #cpu {
        color: #${colors.base09};
      }

      #pulseaudio {
        color: #${colors.base0A};
      }

      #battery {
        color: #${colors.base0C};
      }

      @keyframes blink {
        to {
          color: #${colors.base0F};
        }
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        color: #${colors.base08};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.charging {
        color: #${colors.base0B};
      }

      #network {
        color: #${colors.base0C};
        padding-right: 14px;
      }

      #clock {
        font-family: JetBrainsMono Nerd Font;
        color: #${colors.base0E};
      }

      #custom-power {
        color: #${colors.base0F};
      }

      tooltip {
        border-radius: 8px;
        padding: 15px;
        background-color: #${colors.base01};
      }
    '';
  };
}
