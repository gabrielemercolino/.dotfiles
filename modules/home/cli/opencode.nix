{ self, lib, ... }:
{
  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.opencode ];

    opencode =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.opencode;
      in
      {
        options.gab.cli.opencode = {
          enable = lib.mkEnableOption "opencode";
        };

        config = lib.mkIf cfg.enable {
          programs.opencode.enable = true;
        };
      };
  };
}
