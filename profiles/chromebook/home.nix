{
  pkgs,
  userSettings,
  inputs,
  ...
}:

{
  imports = [
    ../base/home.nix
    ../../gab/home-manager
    ../../user/commands/gab
    inputs.lite-xl.homeManagerModules.default
  ];

  gab.wm.hyprland = {
    enable = true;
    monitors = [ "eDP-1, 1920x1080@60, auto, 1.25" ];
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

    zen = {
      enable = true;
      specific = false;
    };

    telegram.enable = true;

    nvim.enable = true;
    idea-community.enable = true;
  };

  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
  };

  programs.lite-xl = {
    enable = true;
    plugins = with pkgs.lite-xl-plugins; [
      lsp
      widgets
      colorpreview
      console
      gitstatus
      gitdiff_highlight
    ];
    lspServers = with pkgs.lite-xl-lsp; [
      rust_analyzer
      nil
    ];
  };
}
