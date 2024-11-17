{ pkgs, userSettings, ... }:

{
  imports = [
    ../base/home.nix
    ../../gab/home-manager
    ../../user/commands/gab
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;

  gab.wm.hyprland = {
    enable = true;
    monitors = [ "HDMI-A-1, 1920x1080@100, auto, 1" ];
  };

  gab.shell.aliases = {
    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${pkgs.eza}/bin/eza -l --icons";
    la = "${pkgs.eza}/bin/eza -la --icons";
  };
  gab.shell.zsh.enable = true;

  gab.apps = {
    rofi = {
      enable = true;
      wayland = true;
    };
    blueman-applet.enable = true;
    kitty.enable = true;

    gimp.enable = true;
    yazi.enable = true;
    obsidian.enable = true;
    swaylock.enable = true;

    chrome.enable = false;
    zen = {
      enable = true;
      specific = true;
    };

    telegram.enable = true;
    discord.enable = true;

    nvim.enable = true;
    idea-community.enable = true;
    zed-editor.enable = true;

    music.spotify.enable = true;
    music.tracks = [
      {
        url = "https://youtu.be/Jrg9KxGNeJY?si=9_DfB4VwSDHVVBL8";
        fileName = "Bury the light";
      }
      {
        url = "https://youtu.be/qKn2lPyAyqQ";
        fileName = "Bury the light - rock";
      }
    ];
  };

  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
  };

  gab.gaming.mangohud.enable = true;
}
