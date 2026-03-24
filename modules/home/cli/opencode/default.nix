{ self, lib, ... }:
{
  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.opencode ];

    opencode =
      {
        config,
        pkgs,
        ...
      }:
      let
        cfg = config.gab.cli.opencode;
        antigravity-cfg = builtins.readFile ./antigravity.json;
      in
      {
        options.gab.cli.opencode = {
          enable = lib.mkEnableOption "opencode";
          plugins = {
            antigravity.enable = lib.mkEnableOption "antigravity auth & models";
          };
        };

        config = lib.mkIf cfg.enable {
          programs.opencode = {
            enable = true;
            # settings = with cfg.plugins; {
            # plugin = lib.optionals antigravity.enable antigravity-cfg.plugin;
            # provider = lib.optionals antigravity.enable antigravity-cfg.provider;
            # };
          };
        };
      };
  };
}
