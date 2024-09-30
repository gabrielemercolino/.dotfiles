{ pkgs, userSettings, ... }:

{
  imports = [
    ../base/home.nix
    ../../gab/home-manager
    ../../user/commands/gab
  ];

  gab.shell.aliases = {
    ls = "${pkgs.eza}/bin/eza --icons";
    ll = "${pkgs.eza}/bin/eza -l --icons";
    la = "${pkgs.eza}/bin/eza -la --icons";
  };
  gab.shell.zsh = true;

  gab.apps = {
    rofi-wayland = true;
    blueman-applet = true; 

    gimp     = true;
    yazi     = true;
    chrome   = true;
    zen      = true;
    telegram = true;
    kitty    = true;
    obsidian = true;

    nvim           = true;
    idea-community = true;

    git = {
      enable    = true;
      userName  = userSettings.name;
      userEmail = userSettings.email;
    };
  };

  gab.wm.hyprland = true;
}
