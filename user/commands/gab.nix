{ pkgs, userSettings, systemSettings, ... }:

let
  templateDevFlake = "${builtins.toPath ./templateDevFlake.nix}";

  gabScript = ''
set -e

function nixos_update {
  ${pkgs.nh}/bin/nh os switch ${systemSettings.dotfiles} -H system
}

function homemanager_update {
   ${pkgs.nh}/bin/nh home switch ${systemSettings.dotfiles} -c user
}

case $1 in
  sync)
    if [[ "$#" = 1 ]]; then
      nixos_update
      homemanager_update
    elif [[ $2 == "nix" ]]; then
      nixos_update
    elif [[ $2 == "home" ]]; then
      homemanager_update
    else
      echo "Invalid syntax"
      echo "Usage:"
      echo "gab sync (nix | home)"
      echo "    - Rebuilds the system and home-manager following flake configuration in $FLAKE"
      echo "      If 'nix' is specified rebuilds only system, with 'home' only home-manager"
    fi
  ;;
  
  update)
    if [[ "$#" -gt 1 ]]; then
      echo "Invalid syntax"
      echo "Usage:"
      echo "gab update"
      echo "    - Updates flake inputs and applies changes"
      exit 1
    fi
    nix flake update $FLAKE
    nixos_update
    homemanager_update
  ;;

  dev)
    # Prevents creating dev stuff in $HOME
    if [ $(pwd) == "$HOME" ]; then
      echo "Cannot create dev environment in HOME"
      exit 1
    fi

    if [[ "$#" -gt 1 ]]; then
      echo "Invalid syntax"
      echo "Usage:"
      echo "gab dev"
      echo "    - prepares current directory for development providing a default flake.nix and .envrc files"
      echo "      If already present asks if they are needed"
      echo "      For security reasons if run in $HOME it does nothing"
      exit 1
    fi

    # Check if flake.nix file already exists
    if test -f ./flake.nix; then
      echo "flake.nix already exists. Do you want to keep it? [Y/n]"
      read decision

      case $decision in
        "N" | "n")
          rm ./flake.nix
          cp ${templateDevFlake} ./flake.nix
        ;;

        "" | "Y" | "y")
        ;;

        *)
          echo "Invalid response. Aborting"
          exit 1
        ;;
      esac
    else
      cp ${templateDevFlake} ./flake.nix
      fi
    
    # Check if envrc file already exists
    if test -f ./.envrc; then
      echo ".envrc already exists. Do you want to keep it? [Y/n]"
      read decision

      case $decision in
        "N" | "n")
          rm ./.envrc
          echo "Please accept requirements if needed"
          echo "use flake" >> .envrc
          direnv allow
        ;;

        "" | "Y" | "y")
        ;;

        *)
          echo "Invalid response. Aborting"
          exit 1
        ;;

      esac
    else
      echo "Please accept requirements if needed"
      echo "use flake" >> .envrc
      direnv allow
    fi
  ;;

  clean)
    case $2 in 
      "d" | "-d")
        sudo nix-collect-garbage --delete-older-than 30d
      ;;
      
      "")
        nix-collect-garbage
      ;;
      
      *)
        echo "invalid syntax"
        echo "Usage: "
        echo "gab clean (d | -d)"
        echo "    - cleans garbage with nix-collect-garbage"
        echo "      If optional param is provided deletes garbage including derivations older than 30d (requires sudo password)"
        exit 1
      ;;
    esac
  ;;
  
  *)
    echo "Invalid syntax"
    echo "Usage:"
    echo "gab sync (nix | home)"
    echo "    - Rebuilds the system and home-manager following flake configuration in ${systemSettings.dotfiles}"
    echo "      If 'nix' is specified rebuilds only system, with 'home' only home-manager"
      
    echo ""
      
    echo "gab update"
    echo "    - Updates flake inputs and applies changes"

    echo ""

    echo "gab dev"
    echo "    - prepares current directory for development providing a default flake.nix and .envrc files"
    echo "      If already present asks if they are needed"
    echo "      For security reasons if run in $HOME it does nothing"
      
    echo ""

    echo "gab clean (d | -d)"
    echo "    - cleans garbage with nix-collect-garbage"
    echo "      If optional param is provided deletes garbage including derivations older than 30d (requires sudo password)"

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
