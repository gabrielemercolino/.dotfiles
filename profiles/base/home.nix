{userSettings, ...}: {
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # use zsh by default
  gab.shell.zsh.enable = true;

  programs.zellij = {
    enable = true;
    exitShellOnExit = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    settings = {
      pane_frames = false;
      default_layout = "compact";
      default_mode = "locked";
      show_release_notes = false;
      show_startup_tips = false;
      ui = {pane_frames = {hide_session_name = true;};};
    };
  };
}
