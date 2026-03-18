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
        helix-wrapped = pkgs.writeShellScriptBin "hx" ''
          if [ -z "$ZELLIJ" ]; then
            LAYOUT=$(mktemp --suffix=.kdl)
            cat > "$LAYOUT" <<EOF
          layout {
            pane command="${pkgs.helix}/bin/hx" {
              args "$@"
              close_on_exit true
            }
          }
          EOF
            ${pkgs.zellij}/bin/zellij \
              --layout "$LAYOUT"
            rm -f "$LAYOUT"
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

        config = {
          programs.helix = {
            inherit (cfg) enable defaultEditor;
            package = helix-wrapped;
          };
        };
      };
  };
}
