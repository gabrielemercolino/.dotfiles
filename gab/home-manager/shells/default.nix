{
  config,
  lib,
  ...
}: let
  cfg = config.gab.shell;
in {
  options.gab.shell = {
    bash.enable = lib.mkEnableOption "bash";
    zsh.enable = lib.mkEnableOption "zsh";
    nushell.enable = lib.mkEnableOption "nushell";

    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      example = {l = "ls";};
    };

    commands = {
      z.enable = lib.mkEnableOption "zoxide (smarter cd)";
    };
  };

  config = {
    programs = {
      bash = {
        inherit (cfg.bash) enable;
        shellAliases = cfg.aliases;
      };

      oh-my-posh = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
      };

      zsh = {
        inherit (cfg.zsh) enable;
        shellAliases = cfg.aliases;
        oh-my-zsh = {
          enable = true;
          plugins = ["git" "sudo"];
        };
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
      };

      nushell = {
        inherit (cfg.nushell) enable;
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

      # commands
      zoxide = {
        inherit (cfg.commands.z) enable;

        enableBashIntegration = true; # fallback
        enableZshIntegration = cfg.zsh.enable;
        enableNushellIntegration = cfg.nushell.enable;
      };
    };
  };
}
