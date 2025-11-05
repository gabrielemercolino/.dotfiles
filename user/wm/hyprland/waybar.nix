{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.stylix) colors;
  inherit (config.stylix) fonts;
  timezone =
    pkgs.runCommand "timezone" {} ''echo $(timedatectl show --property=Timezone --value) > $out'';
in {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 2;
        exclusive = true;
        gtk-layer-shell = true;
        passthrough = false;
        fixed-center = true;

        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "cpu"
          "memory"
          "pulseaudio"
          "clock"
          "clock#simpleclock"
          "network"
          "battery"
          "tray"
          "custom/power"
        ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "activate";
          persistent-workspaces = {
            "1" = [];
            "2" = [];
            "3" = [];
          };
          all-outputs = true;
          disable-scroll = false;
          active-only = false;
        };

        "hyprland/window" = {
          format = "{initialTitle}";
        };

        cpu = {
          interval = 5;
          format = " {icon}";
          format-icons = ["╸    " "━╸   " "━━╸  " "━━━╸ " "━━━━╸" "━━━━━"];
        };

        memory = {
          interval = 5;
          format = " {icon}";
          format-icons = ["╸    " "━╸   " "━━╸  " "━━━╸ " "━━━━╸" "━━━━━"];
        };

        pulseaudio = {
          tooltip-format = "Volume : {volume}%";
          format = "{icon}";
          format-muted = "       ";
          format-icons = {
            default = ["     " " ╸   " " ━╸  " " ━━╸ " " ━━━╸" " ━━━━"];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        clock = {
          interval = 1;
          format = "󰸘 {:L%a %d %b}";
          timezone = "${timezone}";
          tooltip-format = ''<tt>{calendar}</tt>'';

          calendar.format = {
            today = "<span color='#${colors.base0E}' weight='700'>{}</span>";
          };
        };

        "clock#simpleclock" = {
          tooltip = false;
          format = " {:%H:%M}";
        };

        network = {
          format-wifi = "{icon}";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-ethernet = "󰀂";
          format-alt = "󱛇";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{icon} {essid}\n {bandwidthDownBytes}   {bandwidthUpBytes}";
          tooltip-format-ethernet = "󰀂  {ifname}\n {bandwidthDownBytes}   {bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 5;
          nospacing = 1;
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          format-icons = {
            charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };
          format-full = "Charged ";
          tooltip = false;
        };

        tray = {
          spacing = 10;
          show-passive-items = true;
        };

        "custom/power" = {
          format = "󰤆";
          tooltip = false;
          on-click = "${pkgs.swaylock-effects}/bin/swaylock";
        };
      };
    };

    style = ''
      * {
        min-height: 0;
        min-width: 0;
        font-family: ${fonts.monospace.name}, JetBrainsMono Nerd Font;
        font-size: 14px;
        font-weight: 600;
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
        padding: 0.3rem 1rem;
        margin: 0.2rem;
        border-radius: 6px;
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

      #window,
      #cpu,
      #memory,
      #pulseaudio,
      #clock,
      #battery,
      #network,
      #tray,
      #custom-power {
        padding: 0.3rem 0.6rem;
        margin: 0.2rem;
        border-radius: 6px;
        background-color: #${colors.base01};
      }

      window#waybar.empty #window {
        background-color: transparent;
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
