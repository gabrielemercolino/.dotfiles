{
  lib,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../base/home.nix
    ../../user/commands/gab
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;
  gab = {
    wm = {
      hyprland = {
        enable = true;
        monitors = [
          "HDMI-A-1, 1920x1080@100, auto, 1"
          "DP-1, 1920x1080@100, auto, 1"
        ];
      };

      bspwm = {
        enable = false;
      };
    };

    shell = {
      aliases = rec {
        ls = "${lib.getExe pkgs.eza} --icons";
        ll = "${lib.getExe pkgs.eza} -l --icons";
        la = "${lib.getExe pkgs.eza} -la --icons";

        vi = "hx";
        vim = vi;
        nvim = vi;

        cd = "z"; # from zoxide
      };

      commands.z.enable = true;
    };

    style = {
      theme = "roathe-dark";
    };

    apps = {
      rofi.enable = true;
      kitty.enable = true;

      gimp.enable = true;
      yazi.enable = true;
      obsidian.enable = true;
      swaylock.enable = true;
      aseprite.enable = false;
      tiled.enable = true;

      zen.enable = true;

      telegram.enable = true;
      discord.enable = true;

      helix.enable = true;
      idea-community.enable = true;

      music = {
        mpd.enable = true;
        ncmpcpp.enable = true;
        tracks = [
          {
            url = "https://youtu.be/qKn2lPyAyqQ";
            fileName = "Bury The Light (From ＂Devil May Cry 5 Special Edition＂)";
          }
          {
            url = "https://music.youtube.com/watch?v=vVDYY2F43Vo";
            fileName = "The Electro Suite";
          }
        ];
      };

      resilio.enable = true;
    };

    gaming = {
      mangohud.enable = true;
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      inherit (userSettings) name;
      inherit (userSettings) email;
    };
  };

  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-dash];
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.opencode = {
    enable = true;
    settings = {
      plugin = ["opencode-antigravity-auth@latest"];

      provider = {
        google = {
          models = {
            "antigravity-gemini-3-pro" = {
              name = "Gemini 3 Pro (Antigravity)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              variants = {
                low.thinkingLevel = "low";
                high.thinkingLevel = "high";
              };
            };

            "antigravity-gemini-3-flash" = {
              name = "Gemini 3 Flash (Antigravity)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              variants = {
                minimal.thinkingLevel = "minimal";
                low.thinkingLevel = "low";
                medium.thinkingLevel = "medium";
                high.thinkingLevel = "high";
              };
            };

            "antigravity-claude-sonnet-4-5" = {
              name = "Claude Sonnet 4.5 (Antigravity)";
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
            };

            "antigravity-claude-sonnet-4-5-thinking" = {
              name = "Claude Sonnet 4.5 Thinking (Antigravity)";
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              variants = {
                low.thinkingConfig.thinkingBudget = 8192;
                max.thinkingConfig.thinkingBudget = 32768;
              };
            };

            "antigravity-claude-opus-4-5-thinking" = {
              name = "Claude Opus 4.5 Thinking (Antigravity)";
              limit = {
                context = 200000;
                output = 64000;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
              variants = {
                low.thinkingConfig.thinkingBudget = 8192;
                max.thinkingConfig.thinkingBudget = 32768;
              };
            };

            "gemini-2.5-flash" = {
              name = "Gemini 2.5 Flash (Gemini CLI)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
            };

            "gemini-2.5-pro" = {
              name = "Gemini 2.5 Pro (Gemini CLI)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
            };

            "gemini-3-flash-preview" = {
              name = "Gemini 3 Flash Preview (Gemini CLI)";
              limit = {
                context = 1048576;
                output = 65536;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
            };

            "gemini-3-pro-preview" = {
              name = "Gemini 3 Pro Preview (Gemini CLI)";
              limit = {
                context = 1048576;
                output = 65535;
              };
              modalities = {
                input = ["text" "image" "pdf"];
                output = ["text"];
              };
            };
          };
        };
      };
    };
  };
}
