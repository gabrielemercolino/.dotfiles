{
  pkgs,
  lib,
}: {
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
}
