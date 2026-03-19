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
      aseprite.enable = false;
      tiled.enable = true;

      telegram.enable = true;
      discord.enable = true;

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
