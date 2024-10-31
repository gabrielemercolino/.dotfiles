{ config, lib, ... }:

let
  cfg = config.gab.shell;
in
{
  options.gab.shell = {
    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      example = { l = "ls"; };
    };
    bash.enable    = lib.mkEnableOption "bash";
    zsh.enable     = lib.mkEnableOption "zsh";
    nushell.enable = lib.mkEnableOption "nushell";
  };

  config = {
    programs.zsh = {
      enable = cfg.zsh.enable;
      shellAliases = cfg.aliases;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git" "sudo"];
      };
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;
    };

    programs.nushell = {
      enable = cfg.nushell.enable;
      shellAliases = cfg.aliases;
      extraConfig = ''
        $env.config = {
          # to hide default banner
          show_banner: false,

          # needed to make direnv work automatically
          hooks: {
            pre_prompt: [{ ||
              if (which direnv | is-empty) {
                return
              }

              direnv export json | from json | default {} | load-env
            }]
          }
        }
      '';
    };

    programs.carapace = {
      enable = cfg.nushell.enable;
      enableNushellIntegration = true;
    };

    programs.starship.enable = cfg.nushell.enable;

    programs.bash = {
      enable = cfg.bash.enable;
      shellAliases = cfg.aliases;
    };

  };
}
