{ pkgs, ... }:

let
  myShellAliases = {
   ls = "eza --icons"; 
  };
in
{
  programs.bash = {
    enable = true;
    shellAliases = myShellAliases;
  };

  home.packages = [pkgs.eza];
}
