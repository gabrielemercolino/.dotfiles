{ pkgs, userSettings, ... }:

{
  imports = [
    ../base/home.nix
    ../../gab/home-manager
    ../../user/commands/gab
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;

  gab.shell.aliases = {
    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${pkgs.eza}/bin/eza -l --icons";
    la = "${pkgs.eza}/bin/eza -la --icons";
  };
  gab.shell.zsh = true;

  ########################
  #         APPS         #
  ########################
  gab.apps.utilities.rofi-wayland = true;
  gab.apps.utilities.gimp = true;
  gab.apps.utilities.yazi = true;

  gab.apps.control.blueman-applet = true;

  gab.apps.browsers.chrome = true;

  gab.apps.socials.telegram = true;
  gab.apps.socials.discord  = true;
  
  gab.apps.terminal.kitty  = true;

  gab.apps.dev.git = {
    enable    = true;
    userName  = userSettings.name;
    userEmail = userSettings.email;
  };

  ########################
  #        GAMING        #
  ########################
  gab.gaming.mangohud = true;

  ########################
  #        EDITORS       #
  ########################
  gab.apps.editors.nvim            = true;
  gab.apps.editors.idea-community  = true;
  gab.apps.editors.zed-editor      = true;

  ########################
  #         MUSIC        #
  ########################
  gab.apps.music.spotify = true;

  gab.apps.music.tracks = [
    {
      url = "https://youtu.be/Jrg9KxGNeJY?si=9_DfB4VwSDHVVBL8";
      fileName = "Bury the light";
    }
    {
      url = "https://youtu.be/qKn2lPyAyqQ";
      fileName = "Bury the light - rock";
    }
  ]; 

}
