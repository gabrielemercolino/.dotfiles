{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../base/home.nix
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
        enable = false;
      };
    };

    shell = {
      aliases = {
        ls = "${pkgs.eza}/bin/eza --icons";
        ll = "${pkgs.eza}/bin/eza -l --icons";
        la = "${pkgs.eza}/bin/eza -la --icons";

        cd = "z"; # from zoxide
      };

      commands.z.enable = true;
    };

    style = {
      theme = "syntwave-soft";
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

      nvf.enable = true;
      idea-community.enable = true;

      music = {
        mpd.enable = true;
        rmpc.enable = true;
        tracks = [
          {
            url = "https://youtu.be/qKn2lPyAyqQ";
            fileName = "Bury The Light (From ＂Devil May Cry 5 Special Edition＂)";
          }
          {
            url = "https://music.youtube.com/watch?v=vVDYY2F43Vo";
            fileName = "The Electro Suite";
          }
        ];
      };

      resilio.enable = true;
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
      editor = "nvim"; #TODO: check if it supports something like "$EDITOR"
    };
  };
}
