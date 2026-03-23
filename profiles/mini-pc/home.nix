{ pkgs, ... }:
{
  imports = [ ../base/home.nix ];

  programs.gh = {
    enable = true;
    extensions = [ pkgs.gh-dash ];
    settings = {
      git_protocol = "ssh";
    };
  };
}
