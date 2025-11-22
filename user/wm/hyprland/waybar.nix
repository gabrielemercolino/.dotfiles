{
  config,
  pkgs,
  ...
}: let
  colors = config.lib.stylix.colors.withHashtag;
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
        spacing = 0;
        exclusive = true;
        gtk-layer-shell = true;
        passthrough = false;
        fixed-center = true;

        modules-left = [
          "custom/power"
          "custom/reboot"
          "custom/lock"
          "tray"
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "network"
          "bluetooth"
          "pulseaudio"
          "battery"
          "cpu"
          "memory"
          "clock"
          "clock#simpleclock"
        ];

        "custom/power" = {
          format = " 󰐥 ";
          tooltip = true;
          on-click = "systemctl poweroff";
          tooltip-format = "shutdown";
        };

        "custom/reboot" = {
          format = " 󰜉 ";
          tooltip = true;
          on-click = "systemctl reboot";
          tooltip-format = "reboot";
        };

        "custom/lock" = {
          format = "  ";
          tooltip = true;
          on-click = "${pkgs.swaylock-effects}/bin/swaylock";
          tooltip-format = "lock";
        };

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

        tray = {
          spacing = 10;
          show-passive-items = true;
        };

        "hyprland/window" = {
          format = " {initialTitle} ";
        };

        network = {
          format-wifi = " {icon} {signalStrength}%";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-ethernet = " 󰀂  wired";
          format-disconnected = "󰖪";
          tooltip-format-wifi = "{icon} {essid}\n {bandwidthDownBytes}   {bandwidthUpBytes}";
          tooltip-format-ethernet = "󰀂  {ifname}\n {bandwidthDownBytes}   {bandwidthUpBytes}";
          tooltip-format-disconnected = "Disconnected";
          interval = 5;
          nospacing = 1;
        };

        bluetooth = {
          format-on = " on ";
          format-off = " off ";
          format-disabled = " off ";
          tooltip = true;
        };

        pulseaudio = {
          tooltip-format = "Volume: {volume}%";
          format = " {icon}  {volume}%";
          format-muted = "  ";
          format-icons = {
            default = ["" "" ""];
          };
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = {
            charging = ["󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
            default = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
          };
          format-full = "Charged ";
          tooltip = false;
        };

        cpu = {
          interval = 5;
          format = "  {usage}%";
          tooltip = true;
        };

        memory = {
          interval = 5;
          format = "  {used:0.1f}G ";
          tooltip = true;
          tooltip-format = "Ram: {used:0.2f}G/{total:0.2f}G";
        };

        clock = {
          interval = 1;
          format = " 󰸘 {:L%a %d %b}";
          timezone = "${timezone}";
          tooltip-format = ''<tt>{calendar}</tt>'';

          calendar.format = {
            today = "<span color='${colors.base0E}' weight='700'>{}</span>";
          };
        };

        "clock#simpleclock" = {
          tooltip = false;
          format = " {:%H:%M} ";
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
        background: transparent;
        border: none;
        box-shadow: none;
      }

      #custom-power,
      #custom-reboot,
      #custom-lock {
        padding: 4px 2px;
        background-color: ${colors.base01};
        border-width: 0px;
        margin-top: 6px;
      }

      #custom-power {
        margin-left: 6px;
        border-radius: 10px 0px 0px 10px;
        color: ${colors.base0F};
      }

      #custom-reboot {
        color: ${colors.base09};
      }

      #custom-lock {
        padding-right: 4px; /* center gliph */
        margin-right: 6px;
        border-radius: 0px 10px 10px 0px;
        color: ${colors.base0A};
      }

      #tray {
        padding: 4px 6px;
        margin: 6px;
        margin-bottom: 0px;
        background-color: ${colors.base01};
        border-radius: 10px;
        border-width: 0px;
      }

      #workspaces {
        padding: 4px;
        background-color: ${colors.base01};
        margin: 6px;
        margin-bottom: 0px;
        border-radius: 10px;
        border-width: 0px;
      }

      #workspaces button {
        padding: 4px 10px;
        margin: 0 2px;
        border: none;
        background-color: transparent;
        color: ${colors.base05};
      }

      #workspaces button.active,
      #workspaces button:hover {
        color: ${colors.base01};
        background-color: ${colors.base05};
      }

      #workspaces button.urgent {
        background-color: ${colors.base08};
      }

      #window {
        padding: 4px 6px;
        margin-top: 6px;
        background-color: ${colors.base01};
        border-radius: 10px;
        border-width: 0px;
      }

      window#waybar.empty #window {
        background-color: transparent;
      }

      #network,
      #bluetooth,
      #pulseaudio,
      #battery,
      #cpu,
      #memory,
      #clock {
        padding: 4px 6px;
        margin-top: 6px;
        background-color: ${colors.base01};
        border-width: 0px;
      }

      #network {
        color: ${colors.base0C};
        border-radius: 10px 0 0 10px;
      }

      #bluetooth {
        color: ${colors.base0C};
        margin-right: 6px;
        border-radius: 0px 10px 10px 0px;
      }

      #pulseaudio {
        margin-left: 6px;
        color: ${colors.base0A};
        border-radius: 10px 0px 0px 10px;
      }

      #battery {
        color: ${colors.base0C};
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        color: ${colors.base08};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #battery.charging {
        color: ${colors.base0B};
      }

      @keyframes blink {
        to {
          color: ${colors.base0F};
        }
      }

      #cpu,
      #memory {
        color: ${colors.base09};
      }

      #memory {
        margin-right: 6px;
        border-radius: 0px 10px 10px 0px;
      }

      #clock {
        color: ${colors.base0E};
        margin-left: 6px;
        border-radius: 10px 0px 0px 10px;
      }

      #clock.simpleclock {
        margin-left: 0px;
        margin-right: 6px;
        border-radius: 0px 10px 10px 0px;
      }

      tooltip {
        border-radius: 8px;
        padding: 15px;
        background-color: ${colors.base01};
      }
    '';
  };
}
