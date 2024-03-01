{ pkgs, userSettings, systemSettings, ... }:

let
  templateDevFlake = "${builtins.readFile ./templateDevFlake.nix}";

  gabScript = ''
    set -e

    STARTING_DIR=$(pwd)
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

    function developCase {
      cd $STARTING_DIR
      touch flake.nix
      echo '${templateDevFlake}' > flake.nix
    }

    cd ${systemSettings.dotfiles}

    case $OPERATION in

      sync)
      syncCase
      ;;

      update)
      updateCase
      ;;

      dev)
      developCase
      ;;

      *)
      echo "WTF"
      exit 1
      ;;

    esac

    cd $STARTING_DIR
  '';
in
{
  home.packages = [
    (pkgs.writeScriptBin "gab" gabScript)
  ];
}