{
  lib,
  pkgs,
  ...
}: {
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

        video = [
          {
            run = ''${lib.getExe pkgs.mpv} "$@"'';
            block = true;
          }
        ];

        image = [
          {
            run = ''${lib.getExe pkgs.imv} "$@"'';
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
            use = "video";
          }
          {
            mime = "image/*";
            use = "image";
          }
        ];
      };
    };
  };
}
