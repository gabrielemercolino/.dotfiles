{config, ...}: let
  inherit (config.lib.stylix) colors;
in {
  programs.ashell = {
    enable = true;

    settings = {
      modules = {
        center = [
          "Clock"
        ];
        left = [
          "Workspaces"
        ];
        right = [
          "SystemInfo"
          [
            "Settings"
          ]
        ];
      };
      workspaces = {
        visibility_mode = "MonitorSpecific";
      };

      appearance = {
      };
    };
  };
}
