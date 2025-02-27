{
  pkgs,
  userSettings,
  inputs,
  ...
}: {
  imports = [
    ../base/home.nix
    ../../gab/home-manager
    ../../user/commands/gab
    inputs.lite-xl.homeManagerModules.default
  ];

  gab.wm.hyprland = {
    enable = false;
    monitors = ["eDP-1, 1920x1080@60, auto, 1.25"];
  };

  gab.wm.bspwm = {
    enable = true;
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
      wayland = false;
    };
    blueman-applet.enable = true;
    kitty.enable = true;

    gimp.enable = true;
    yazi.enable = true;
    obsidian.enable = true;
    swaylock.enable = true;

    zen.enable = true;

    telegram.enable = true;

    nvf.enable = true;
    idea-community.enable = true;
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
      lintplus
      bracketmatch
    ];
    lspServers = with pkgs.lite-xl-lsp; [
      nil
      elixir-ls
    ];
  };

  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
  };
}
