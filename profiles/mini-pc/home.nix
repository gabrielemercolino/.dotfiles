{
  lib,
  pkgs,
  userSettings,
  ...
}:
{
  imports = [
    ../base/home.nix
    ../../gab/cli/gab
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;
  gab = {
    apps = {
      rofi.enable = true;
      kitty.enable = true;

      gimp.enable = true;
      obsidian.enable = true;
      aseprite.enable = false;
      tiled.enable = true;

      telegram.enable = true;
      discord.enable = true;

      idea-community.enable = true;

      music = {
        mpd.enable = true;
        ncmpcpp.enable = true;
      };

      resilio.enable = true;
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      inherit (userSettings) name;
      inherit (userSettings) email;
    };
  };

  programs.jujutsu = {
    enable = true;
    settings.user = {
      inherit (userSettings) name;
      inherit (userSettings) email;
    };
  };

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-dash ];
    settings = {
      git_protocol = "ssh";
    };
  };
}
