{...}: {
  programs.yazi = {
    settings = {
      mgr = {
        show_hidden = true;
      };

      opener = {
        edit = [
          {
            run = ''$EDITOR "$@"'';
            block = true;
          }
        ];

        xdg = [
          {
            run = ''xdg-open "$@"'';
            block = true;
          }
        ];
      };
      open = {
        rules = [
          {
            mime = "text/*";
            use = "edit";
          }
          {
            mime = "video/*";
            use = "xdg";
          }
          {
            mime = "image/*";
            use = "xdg";
          }
        ];
      };
    };
  };
}
