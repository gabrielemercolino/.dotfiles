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

  ########################
  #         APPS         #
  ########################
  gab.apps.utilities.rofi-wayland = true;
  gab.apps.utilities.gimp = true;
  gab.apps.utilities.yazi = true;

  gab.apps.control.blueman-applet = true;

  gab.apps.browsers.chrome = true;

  gab.apps.socials.telegram = true;

  gab.apps.terminal.kitty  = true;

  gab.apps.dev.git = {
    enable    = true;
    userName  = userSettings.name;
    userEmail = userSettings.email;
  };

  ########################
  #        EDITORS       #
  ########################
  gab.apps.editors.nvim            = true;
  gab.apps.editors.idea-community  = true;
}
