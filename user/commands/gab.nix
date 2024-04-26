{ pkgs, userSettings, systemSettings, ... }:

let
  templateDevFlake = "${builtins.readFile ./templateDevFlake.nix}";

  gabScript = ''
    set -e

    OPERATION=$1
    SPECIFICATION=$2

    function nixos_update {
      sudo nixos-rebuild switch --flake ${systemSettings.dotfiles}#system
    }

    function homemanager_update {
      nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ${systemSettings.dotfiles}#user
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
        nix flake update ${systemSettings.dotfiles}
        ;;

        *)
        #nix flake lock ${systemSettings.dotfiles} --update-input $SPECIFICATION
        exit 1
        ;;

      esac

      nixos_update
      homemanager_update
    }

    function developCase {
      touch flake.nix
      echo '${templateDevFlake}' > flake.nix
    }
    
    function cleanCase {
      case $SPECIFICATION in
      
        "")
        nix-collect-garbage
        ;;

        "d")
        nix-collect-garbage -d
        ;;

        *)
        echo invalid syntax
        exit 1
        ;;

      esac
    }

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

      clean)
      cleanCase
      ;;

      *)
      exit 1
      ;;

    esac
  '';
in
{
  home.packages = [
    (pkgs.writeScriptBin "gab" gabScript)
  ];
}
