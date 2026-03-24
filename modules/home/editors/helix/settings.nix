{ lib, ... }:
{
  flake.modules.homeManager.helix =
    { pkgs, ... }:
    {
      programs.helix.settings = {
        editor = {
          auto-format = true;
          line-number = "relative";
          bufferline = "multiple";
          color-modes = true;
          popup-border = "all";

          statusline = {
            left = [
              "mode"
              "spacer"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            center = [ "version-control" ];
            right = [
              "spinner"
              "file-type"
              "diagnostics"
              "position"
              "position-percentage"
            ];
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
          C-q = ":q";
          C-s = ":w";
          C-f = ":fmt";
          C-w = ":buffer-close";
          C-right = ":buffer-next";
          C-left = ":buffer-previous";

          g = {
            d = "goto_definition";
            D = "goto_declaration";
            t = "goto_type_definition";
            y = "no_op";
          };

          space = {
            f.g = "global_search";
            f.f = "file_picker";
            "/" = "no_op";
          };
        };
      };
    };
}
