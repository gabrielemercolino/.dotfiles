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
