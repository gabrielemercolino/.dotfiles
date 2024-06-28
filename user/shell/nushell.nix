{...}:

let
myShellAliases = {
    l = "ls";
    la = "ls -a";
  };
in
{
  programs = {
    nushell = {
      enable = true;
      shellAliases = myShellAliases;
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

    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };

    starship = {
      enable = true;
    };
  };
}
