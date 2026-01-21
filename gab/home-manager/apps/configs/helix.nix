{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
  helix-wrapped = pkgs.writeShellScriptBin "hx" ''
    if [ -z "$ZELLIJ" ]; then
      LAYOUT=$(mktemp --suffix=.kdl)
      cat > "$LAYOUT" <<EOF
    layout {
      pane command="${pkgs.helix}/bin/hx" {
        args "$@"
        close_on_exit true
      }
    }
    EOF
      ${pkgs.zellij}/bin/zellij \
        --layout "$LAYOUT"
      rm -f "$LAYOUT"
    else
      exec ${pkgs.helix}/bin/hx "$@"
    fi
  '';
in {
  programs.helix = lib.mkIf cfg.helix.enable {
    package = helix-wrapped;

    defaultEditor = true;

    settings = {
      editor = {
        auto-format = true;
        line-number = "relative";
        bufferline = "multiple";
        color-modes = true;
        popup-border = "all";

        statusline = {
          left = ["mode" "spacer" "file-name" "read-only-indicator" "file-modification-indicator"];
          center = ["version-control"];
          right = ["spinner" "file-type" "diagnostics" "position" "position-percentage"];
        };

        cursor-shape = {
          normal = "block";
          insert = "bar";
          select = "underline";
        };

        lsp = {
          display-progress-messages = true;
          display-inlay-hints = true;
        };

        auto-save = {
          focus-lost = true;
        };

        indent-guides = {
          render = true;
          character = "▏";
          skip-levels = 1;
        };

        inline-diagnostics = {
          cursor-line = "hint";
          other-lines = "warning";
        };
      };

      keys.normal = {
        C-q = ":wq";
        C-s = ":w";
        C-f = [":fmt" ":w"];
        C-w = ":buffer-close";
        C-right = ":buffer-next";
        C-left = ":buffer-previous";

        g.d = "goto_definition";
        g.D = "goto_declaration";
        g.t = "goto_type_definition";
        g.y = "no_op";

        space = {
          g.g = ":sh ${pkgs.zellij}/bin/zellij run -c -f -x 10%% -y 10%% --width 80%% --height 80%% -- ${lib.getExe pkgs.lazygit}";

          f.g = "global_search";
          f.f = "file_picker";
          "/" = "no_op";
        };
      };
    };

    languages = {
      language-server = {
        nil.command = "${lib.getExe pkgs.nil}";
        bash-language-server.command = "${lib.getExe pkgs.bash-language-server}";
        clangd.command = "${pkgs.clang-tools}/bin/clangd";
        cmake-language-server.command = "${lib.getExe pkgs.cmake-language-server}";
        elixir-ls.command = "${lib.getExe pkgs.elixir-ls}";
        gopls.command = "${lib.getExe pkgs.gopls}";
        markdown-oxide.command = "${lib.getExe pkgs.markdown-oxide}";
        rust-analyzer.command = "${lib.getExe pkgs.rust-analyzer}";
        vscode-css-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
        typescript-language-server = {
          command = "${lib.getExe pkgs.typescript-language-server}";
          config = {
            typescript.inlayHints = {
              includeInlayEnumMemberValueHints = true;
              includeInlayFunctionLikeReturnTypeHints = false;
              includeInlayFunctionParameterTypeHints = false;
              includeInlayParameterNameHints = "literals";
              includeInlayParameterNameHintsWhenArgumentMatchesName = true;
              includeInlayPropertyDeclarationTypeHints = false;
              includeInlayVariableTypeHints = false;
            };
          };
        };
        yaml-language-server.command = "${lib.getExe pkgs.yaml-language-server}";
        ruff.command = "${lib.getExe pkgs.ruff}";
      };

      language = [
        {
          name = "nix";
          file-types = ["nix"];
          formatter.command = "${lib.getExe pkgs.alejandra}";
        }
      ];
    };
  };
}
