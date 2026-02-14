{
  lib,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../base/home.nix
    ./theme.nix
    ../../gab/cli/gab
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;
  gab = {
    wm = {
      hyprland = {
        enable = true;
        monitors = [
          "HDMI-A-1, 1920x1080@100, auto, 1"
          "DP-1, 1920x1080@100, auto, 1"
        ];
      };
    };

    shell = {
      aliases = rec {
        ls = "${lib.getExe pkgs.eza} --icons";
        ll = "${lib.getExe pkgs.eza} -l --icons";
        la = "${lib.getExe pkgs.eza} -la --icons";

        vi = "hx";
        vim = vi;
        nvim = vi;

        cd = "z"; # from zoxide
      };
    };

    apps = {
      rofi.enable = true;
      kitty.enable = true;

      gimp.enable = true;
      yazi.enable = true;
      obsidian.enable = true;
      swaylock.enable = true;
      aseprite.enable = false;
      tiled.enable = true;

      zen.enable = true;

      telegram.enable = true;
      discord.enable = true;

      helix.enable = true;
      idea-community.enable = true;

      opencode = {
        enable = true;
        plugins.antigravity.enable = true;
      };

      music = {
        mpd.enable = true;
        ncmpcpp.enable = true;
      };

      resilio.enable = true;
      zoxide.enable = true;
    };

    gaming = {
      mangohud.enable = true;
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      inherit (userSettings) name;
      inherit (userSettings) email;
    };
  };

  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-dash];
    settings = {
      git_protocol = "ssh";
    };
  };
}
