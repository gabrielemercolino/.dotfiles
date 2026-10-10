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
            settings = {
              theme = "cc-dark";
              packages = [ "npm:pi-cc-extensions" ];
            };
          };

          xdg.configFile."pi/agent/pi-cc-extensions.json".text = builtins.toJSON {
            editDiffCollapsedLines = 500;
            writeDiffCollapsedLines = 500;
          };
        };
      };
  };
}
