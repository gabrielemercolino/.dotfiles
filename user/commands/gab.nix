{ pkgs, userSettings, ... }:

let
  gabScript = ''
    set -e

    STARTING_DIR = $(pwd)

    function nixos_update {
      sudo nixos-rebuild switch --flake .#system
    }

    function homemanager_update {
      home-manager switch --flake .#user
    }

    cd ~/.dotfiles
    nixos_update
    homemanager_update
    cd $STARTING_DIR
  '';
in
{
  home.packages = [
    (pkgs.writeScriptBin "gab" gabScript)
  ];
}