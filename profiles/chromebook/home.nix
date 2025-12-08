{
  lib,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../base/home.nix
    ../../user/commands/gab
  ];
  gab = {
    wm = {
      hyprland = {
        enable = true;
        monitors = ["eDP-1, 1920x1080@60, auto, 1" "DP-2, 1920x1080@60, auto, 1, mirror, eDP-1"];
      };

      bspwm = {
        enable = false;
      };
    };

    shell = {
      aliases = rec {
        ls = "${pkgs.eza}/bin/eza --icons";
        ll = "${pkgs.eza}/bin/eza -l --icons";
        la = "${pkgs.eza}/bin/eza -la --icons";

        vi = "${lib.getExe pkgs.helix}";
        vim = vi;
        nvim = vi;

        cd = "z"; # from zoxide
      };

      commands.z.enable = true;
    };
    apps = {
      rofi.enable = true;
      kitty.enable = true;

      gimp.enable = true;
      yazi.enable = true;
      obsidian.enable = true;
      swaylock.enable = true;

      zen.enable = true;

      telegram.enable = true;

      helix.enable = true;
      idea-community.enable = true;

      resilio.enable = true;
    };

    style = {
      theme = "gruvbox-dark";
      fonts.sizes = {
        applications = 14;
        desktop = 12;
        popups = 12;
        terminal = 14;
      };
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      inherit (userSettings) name;
      inherit (userSettings) email;
    };
  };
}
