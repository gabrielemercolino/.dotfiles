{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../gab/home-manager
  ];

  xdg =
    let
      xdg = import ./xdg.nix { inherit config lib pkgs; };
    in
    {
      enable = true;
      desktopEntries = xdg.desktopEntries;
      mimeApps = {
        enable = true;
        defaultApplications = xdg.defaultApplications;
      };
    };

  programs.zellij = {
    enable = true;
    settings = {
      on_force_close = "quit";
      pane_frames = false;
      default_layout = "compact";
      default_mode = "locked";
      show_release_notes = false;
      show_startup_tips = false;
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
    };
  };
}
