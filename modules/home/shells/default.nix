{ lib, ... }:
{
  flake.modules.homeManager.shell =
    {
      config,
      pkgs,
      ...
    }:
    let
      cfg = config.gab.shell;
    in
    {
      options.gab.shell = {
        zsh.enable = lib.mkEnableOption "zsh";

        aliases = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          example = {
            l = "ls";
          };
        };
      };

      config = {
        programs = {
          bash = {
            enable = true;
            shellAliases = cfg.aliases;
          };

          zsh = {
            inherit (cfg.zsh) enable;
            dotDir = "${config.xdg.configHome}/zsh";
            shellAliases = cfg.aliases;
            syntaxHighlighting.enable = true;
            autosuggestion.enable = true;
          };

          oh-my-posh = {
            enable = true;
            configFile = ./oh-my-posh.yaml;

            enableBashIntegration = true;
            enableZshIntegration = true;
            enableNushellIntegration = true;
          };

          zoxide = {
            enable = true;

            enableBashIntegration = true;
            enableZshIntegration = true;
            enableNushellIntegration = true;
          };
        };
      };
    };
}
