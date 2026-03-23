{
  config,
  lib,
  ...
}:
{
  flake.modules.homeManager = {
    editors.imports = [ config.flake.modules.homeManager.helix ];

    helix =
      {
        config,
        pkgs,
        ...
      }:
      let
        cfg = config.gab.editors.helix;
        zellij-config =
          pkgs.writeText "zellij.kdl"
            #kdl
            ''
              on_force_close "quit"
              pane_frames false
              default_layout "compact"
              default_mode "locked"
              show_release_notes false
              show_startup_tips false
              ui {
                  pane_frames {
                      hide_session_name true
                  }
              }
            '';
        zellij-layout =
          pkgs.writeText "layout.kdl"
            #kdl
            ''
              layout {
                pane command="${pkgs.helix}/bin/hx" {
                  args "$@"
                  close_on_exit true
                }
              }
            '';
        helix-wrapped = pkgs.writeShellScriptBin "hx" ''
          if [ -z "$ZELLIJ" ]; then
            ${pkgs.zellij}/bin/zellij \
              --config "${zellij-config}" \
              --layout "${zellij-layout}"
          else
            exec ${pkgs.helix}/bin/hx "$@"
          fi
        '';
      in
      {
        options.gab.editors.helix = {
          enable = lib.mkEnableOption "helix";
          defaultEditor = lib.mkEnableOption "helix as default editor" // {
            default = true;
          };
        };

        config = lib.mkIf cfg.enable {
          programs.helix = {
            enable = true;
            defaultEditor = cfg.defaultEditor;
            package = helix-wrapped;
          };
          xdg.configFile = {
            "helix/config.kdl".source = zellij-config;
            "helix/layout.kdl".source = zellij-layout;
          };
        };
      };
  };
}
