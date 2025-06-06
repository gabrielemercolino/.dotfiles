{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../base/home.nix
    ../../gab/home-manager
    ../../user/commands/gab
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;
  gab = {
    wm = {
      hyprland = {
        enable = true;
        monitors = ["HDMI-A-1, 1920x1080@100, auto, 1" "DP-1, 1920x1080@100, auto, 1"];
      };

      bspwm = {
        enable = true;
      };
    };
    shell = {
      zsh.enable = true;

      aliases = {
        ls = "${pkgs.eza}/bin/eza --icons";
        ll = "${pkgs.eza}/bin/eza -l --icons";
        la = "${pkgs.eza}/bin/eza -la --icons";
      };
    };

    apps = {
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
      aseprite.enable = true;
      tiled.enable = true;

      zen.enable = true;

      telegram.enable = true;
      discord.enable = true;

      nvf.enable = true;
      idea-community.enable = true;

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

      resilio.enable = true;
    };

    gaming = {
      mangohud.enable = true;
      geforce.enable = true;
    };
  };

  programs.git = {
    enable = true;
    userName = userSettings.name;
    userEmail = userSettings.email;
  };

  programs.gh = {
    enable = true;
    extensions = [pkgs.gh-dash];
    settings = {
      git_protocol = "ssh";
      editor = "nvim"; #TODO: check if it supports something like "$EDITOR"
    };
  };
}
