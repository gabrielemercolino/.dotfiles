{ lib, ... }:
{
  flake.modules.homeManager = {
    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent = {
            extraPackages = [ pkgs.nodejs ];
            settings.packages = [ "npm:@gotgenes/pi-session-tools" ];
          };
        };
      };
  };
}
