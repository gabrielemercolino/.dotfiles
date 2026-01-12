{...}: {
  programs.yazi = {
    settings = {
      mgr = {
        show_hidden = true;
      };

      opener = {
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
            use = "xdg";
          }
          {
            mime = "video/*";
            use = "xdg";
          }
          {
            mime = "image/*";
            use = "xdg";
          }
          {
            mime = "application/*";
            use = "xdg";
          }
        ];
      };
    };
  };
}
