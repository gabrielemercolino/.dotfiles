{
  pkgs,
  userSettings,
  lib,
  ...
}:

let
  hyprpanelNar = ../../nar-cache/hyprpanel.nar;
  hyprpanelStorePath = "/nix/store/g3xsrgwsfnyc1x8xk9cqpn8f1cq4mk55-hyprpanel";
in
{
  home.activation.importNar = lib.hm.dag.entryBefore [ "writeBoundary" ] ''
    if ! nix store verify-path ${hyprpanelStorePath}; then
        echo "Importing ${hyprpanelNar} into the Nix store..."
        nix store import < ${hyprpanelNar}
    else
        echo "Package ${hyprpanelStorePath} already exists in the store."
    fi
  '';

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

  gab.wm.hyprland = {
    enable = true;
    monitors = [ "eDP-1, 1920x1080@60, auto, 1.25" ];
  };
}
