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
          };
        };
      };
  };
}
