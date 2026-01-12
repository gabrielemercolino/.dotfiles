{
  config,
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

  xdg = let
    xdg = import ./xdg.nix {inherit config lib pkgs;};
  in {
    enable = true;
    desktopEntries = xdg.desktopEntries;
    mimeApps = {
      enable = true;
      defaultApplications = xdg.defaultApplications;
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
