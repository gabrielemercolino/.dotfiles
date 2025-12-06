{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  programs.helix = lib.mkIf cfg.helix.enable {
    defaultEditor = true;

    settings = {
      editor = {
        auto-format = true;
        line-number = "relative";
        bufferline = "multiple";
        color-modes = true;
        popup-border = "all";

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
        C-f = ":fmt";

        space.g.g = [
          ":write-all"
          ":new"
          ":insert-output ${lib.getExe pkgs.lazygit}"
          ":set mouse false"
          ":set mouse true"
          ":buffer-close!"
          ":redraw"
          ":reload-all"
        ];
      };
    };

    languages = {
      language-server = {
        nil.command = "${lib.getExe pkgs.nil}";
        bash-language-server.command = "${lib.getExe pkgs.bash-language-server}";
        clangd.command = "${pkgs.clang-tools}/bin/clangd";
        cmake-language-server.command = "${lib.getExe pkgs.cmake-language-server}";
        csharp-ls.command = "${lib.getExe pkgs.csharp-ls}";
        elixir-ls.command = "${lib.getExe pkgs.elixir-ls}";
        kotlin-language-server.command = "${lib.getExe pkgs.kotlin-language-server}";
        markdown-oxide.command = "${lib.getExe pkgs.markdown-oxide}";
        rust-analyzer.command = "${lib.getExe pkgs.rust-analyzer}";
        vscode-css-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
        typescript-language-server.command = "${lib.getExe pkgs.typescript-language-server}";
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
