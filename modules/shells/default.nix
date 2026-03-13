{lib, ...}: {
  flake.homeModules.shells = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.shells;
  in {
    options.gab.shells = {
      zsh.enable = lib.mkEnableOption "zsh";

      aliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        example = {l = "ls";};
      };
    };

    config = {
      programs = {
        oh-my-posh = {
          enable = true;
          configFile = pkgs.writeText ./oh-my-posh.yaml;

          enableBashIntegration = true;
          enableZshIntegration = true;
          enableNushellIntegration = true;
        };

        programs.zoxide = {
          enable = true;

          enableBashIntegration = true;
          enableZshIntegration = true;
          enableNushellIntegration = true;
        };

        bash = {
          enable = true;
          shellAliases = config.gab.shells.aliases;
        };

        zsh = {
          inherit (cfg.zsh) enable;
          dotDir = "${config.xdg.configHome}/zsh";
          shellAliases = cfg.aliases;
          syntaxHighlighting.enable = true;
          autosuggestion.enable = true;
        };
      };
    };
  };
}
