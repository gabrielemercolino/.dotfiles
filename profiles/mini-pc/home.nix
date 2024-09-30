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

  gab.apps = {
    rofi-wayland   = true;
    blueman-applet = true; 
    kitty    = true;

    gimp     = true;
    yazi     = true;
    obsidian = true;

    chrome = true;
    zen    = true;

    telegram = true;
    discord  = true;
    
    nvim           = true;
    idea-community = true;
    zed-editor     = true;

    git = {
      enable    = true;
      userName  = userSettings.name;
      userEmail = userSettings.email;
    };

    music.spotify = true;
    music.tracks  = [
      { url = "https://youtu.be/Jrg9KxGNeJY?si=9_DfB4VwSDHVVBL8"; fileName = "Bury the light"; }
      { url = "https://youtu.be/qKn2lPyAyqQ";                     fileName = "Bury the light - rock"; }
    ];
  };

  gab.gaming.mangohud = true;

  gab.wm.hyprland = true;
}
