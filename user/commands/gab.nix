{ pkgs, userSettings, systemSettings, ... }:

let
  gabScript = ''
    set -e

    STARTING_DIR=$(pwd)
    ERROR="0"
    OPERATION=$1
    SPECIFICATION=$2

    function nixos_update {
      sudo nixos-rebuild switch --flake .#system
    }

    function homemanager_update {
      home-manager switch --flake .#user
    }

    function syncCase {
      case $SPECIFICATION in
        
        home)
        homemanager_update
        ;;

        nix)
        nixos_update
        ;;

        *)
        nixos_update
        homemanager_update
        ;;

      esac
    }

    function updateCase {
      case $SPECIFICATION in
        
        "")
        nix flake update
        ;;

        *)
        nix flake lock --update-input $SPECIFICATION
        ;;

      esac

      nixos_update
      homemanager_update
    }

    cd ${systemSettings.dotfiles}

    case $OPERATION in

      sync)
      syncCase
      ;;

      update)
      updateCase
      ;;

      *)
      echo "WTF"
      ERROR="1"
      ;;

    esac

    cd $STARTING_DIR

    [[ $ERROR == "1" ]] && exit 1 || exit 0
  '';
in
{
  home.packages = [
    (pkgs.writeScriptBin "gab" gabScript)
  ];
}