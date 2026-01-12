{
  userSettings,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # just import the config, enables actually control the installation
    ../../user/wm/hyprland
    ../../user/wm/bspwm
    ../../gab/home-manager
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [];
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.userName;
  home.homeDirectory = "/home/${userSettings.userName}";

  home.stateVersion = "24.11";

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let
        browser = ["zen-beta.desktop"];
        imageViewer = ["imv.desktop"];
        imageEditor = ["gimp.desktop"];
        videoViewer = ["mpv.desktop"];

        commonImages = ["image/png" "image/jpeg" "image/jpg" "image/gif" "image/webp" "image/bmp" "image/tiff" "image/svg+xml"];
        gimpFormats = ["image/x-xcf" "image/x-psd" "image/x-xcfgz"];

        videoFormats = ["video/mp4" "video/x-matroska" "video/webm" "video/mpeg" "video/x-msvideo" "video/quicktime" "video/x-flv" "video/ogg"];

        toMimeAttrs = formats: opener:
          formats
          |> map (n: {
            name = n;
            value = opener;
          })
          |> builtins.listToAttrs;
      in
        lib.mkMerge [
          (toMimeAttrs commonImages imageViewer)
          (toMimeAttrs gimpFormats imageEditor)
          (toMimeAttrs videoFormats videoViewer)
          {
            "text/html" = browser;
            "application/xhtml+xml" = browser;
          }
        ];
    };
    desktopEntries = {
      imv = {
        name = "imv";
        exec = "${lib.getExe pkgs.imv}";
      };
      mpv = {
        name = "mpv";
        exec = "${lib.getExe pkgs.mpv} --keep-open=yes";
      };
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # use zsh by default
  gab.shell.zsh.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      on_force_close = "quit";
      pane_frames = false;
      default_layout = "compact";
      default_mode = "locked";
      show_release_notes = false;
      show_startup_tips = false;
      ui = {pane_frames = {hide_session_name = true;};};
    };
  };
}
