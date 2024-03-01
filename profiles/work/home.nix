{ config, pkgs, userSettings, ... }:

{
  imports = [
	../../user/shell/sh.nix
  ../../user/shell/utility.nix
  ../../user/commands/gab.nix
	(./. + ("../../../user/wm/"+userSettings.wm)+"/config.nix")
	(./. + ("../../../user/apps/browsers/"+userSettings.browser)+".nix")
	(./. + ("../../../user/apps/terminal/"+userSettings.terminal)+".nix")
  ../../user/apps/git/config.nix
  ../../user/apps/editors/sublime.nix
  ../../user/apps/editors/jetbrains.nix
  ../../user/apps/editors/neovim.nix
  ../../user/languages/config.nix
  ];  

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_ : true);
    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = userSettings.userName;
  home.homeDirectory = "/home/${userSettings.userName}";
  
  home.stateVersion = "23.11";

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
  	
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/gabriele/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
