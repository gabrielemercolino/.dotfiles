{
  ags-bar,
  pkgs,
  config,
}: let
  colors = config.lib.stylix.colors.withHashtag;
  inherit (config.stylix) fonts;
  system = pkgs.stdenv.hostPlatform.system;
in
  ags-bar.packages.${system}.default.override {
    colors = {
      bg-color = colors.base01;
      fg-shutdown = colors.base0F;
      fg-reboot = colors.base09;
      fg-lock = colors.base0A;

      bg-workspace-active = colors.base05;
      fg-workspace-active = colors.base01;

      fg-title = colors.base05;

      fg-connection = colors.base0C;
      fg-connection-hover = colors.base0E;

      fg-battery = colors.base0A;
      fg-battery-charging = colors.base09;

      fg-audio = colors.base0A;
      fg-audio-hover = colors.base09;

      fg-date = colors.base0E;
      fg-date-hover = colors.base08;

      fg-calendar-today = colors.base0E;
      bg-calendar-selected = colors.base0E;
      fg-calendar-today-outline = colors.base0E;

      fg-clock = colors.base0E;

      fg-notifications-app-border = colors.base0E;
      fg-notifications-app-name = colors.base0C;
      bg-notifications-app = "rgba(${colors.base0E}, 0.05)";

      fg-notifications-summary = colors.base0C;
    };
  }
