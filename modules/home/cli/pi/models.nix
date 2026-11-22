{ lib, ... }:
{
  flake.modules.homeManager = {
    pi =
      { config, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent.models.providers.deepseek.modelOverrides = {
            deepseek-flash = {
              contextWindow = 200000;
            };
            deepseek-v4-pro = {
              contextWindow = 200000;
            };
          };
        };
      };
  };
}
