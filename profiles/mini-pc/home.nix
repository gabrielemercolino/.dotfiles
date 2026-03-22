{ pkgs, ... }:
{
  imports = [
    ../base/home.nix
    ../../gab/cli/gab
  ];

  gab = {
    apps = {
      rofi.enable = true;
      kitty.enable = true;

      gimp.enable = true;
      obsidian.enable = true;
      aseprite.enable = false;
      tiled.enable = true;

      idea-community.enable = true;

      resilio.enable = true;
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
