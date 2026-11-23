{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos = {
    hm.imports = [ self.modules.nixos.dsh-hm ];

    dsh-hm = {
      nixpkgs.overlays = [ inputs.deepseek-harness.overlays.default ];
    };
  };

  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.dsh ];

    dsh =
      {
        config,
        pkgs,
        host,
        ...
      }:
      let
        cfg = config.gab.cli.dsh;

        tuiSettings = pkgs.writeText "dsh-tui-settings.json" (
          builtins.toJSON {
            version = 1;
            values = {
              lang = "en";
              thinkingFold = "full";
              toolBackground = "subtle";
              scrollGutter = "hidden";
              codeFrameStyle = "light";
              statusBar = {
                tokens = true;
                compact = true;
                contextBar = false;
                activity = false;
                tps = false;
                trajectory = false;
                cost = false;
              };
            };
          }
        );

        tuiThemeChoice = pkgs.writeText "dsh-tui-theme.json" (builtins.toJSON { theme = "cc-dark"; });
      in
      {
        imports = [ inputs.deepseek-harness.homeModules.default ];

        options.gab.cli.dsh = {
          enable = lib.mkEnableOption "DeepSeek Harness (dsh)";
        };

        config = lib.mkIf cfg.enable {
          programs.dsh = {
            enable = true;

            package = inputs.deepseek-harness.packages.${host.system}.dsh;
            defaultProfile = config.programs.dsh.profiles.tui.materializedName;

            patch = [
              {
                id = "llm-deepseek";
                config = {
                  models = [
                    {
                      id = "deepseek-flash";
                      name = "DeepSeek-V4.1-Flash";
                      contextWindow = 250000;
                      maxTokens = 32768;
                      inputModalities = [
                        "text"
                        "image"
                      ];
                      systemPromptUpdate = "in-history";
                      toolUpdate = "addition-only";
                    }
                    {
                      id = "deepseek-v4-pro";
                      name = "DeepSeek-V4-Pro";
                      description = "Stronger agentic coding, knowledge, and difficult reasoning; suited to complex or quality-critical tasks at higher cost.";
                      contextWindow = 250000;
                      maxTokens = 32768;
                    }
                  ];
                };
              }
              {
                # The signed-in route reads its catalog from the account
                # listing, so it takes per-model overrides instead.
                id = "llm-deepseek-account";
                config.modelOverrides = {
                  deepseek-flash = {
                    contextWindow = 250000;
                    maxTokens = 32768;
                  };
                  deepseek-v4-pro = {
                    contextWindow = 250000;
                    maxTokens = 32768;
                  };
                };
              }
            ];
          };

          sops.secrets."deepseek/key" = { };

          sops.templates."dsh/.env" = {
            path = "${config.home.homeDirectory}/.dsh/.env";
            content = "DEEPSEEK_API_KEY=${config.sops.placeholder."deepseek/key"}\n";
          };

          services.dsh = {
            enable = true;
            autoStart = true;
          };

          home.activation.dshTuiSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            run install -Dm600 ${tuiSettings} "$HOME/.dsh-tui/settings.json"
            run install -Dm644 ${tuiThemeChoice} "$HOME/.dsh-tui/theme.json"
          '';

          home.file = {
            ".dsh-tui/themes/cc-dark.json".source = ./themes/cc-dark.json;

            ".dsh/AGENTS.md".source = ../pi/APPEND_SYSTEM.md;

            ".dsh/skills/versioning-preferences".source = ../pi/skills/versioning-preferences;
          };
        };
      };
  };
}
