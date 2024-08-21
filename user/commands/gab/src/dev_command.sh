flake_init () {
  echo '
  {
    description = "template dev flake";
    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    inputs.flake-utils.url = "github:numtide/flake-utils";

    outputs = { nixpkgs, flake-utils, ... }:
      flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {inherit system;};
        in
        {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [];
            buildInputs = with pkgs; [];
            shellHook = "clear && echo \"Welcome!\" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat";
          };
        }
      );
  }' > flake.nix
}

envrc_init () {
  echo 'use flake' > .envrc
}

# check if in $HOME
if [ $PWD == $HOME ]; then
  echo 'Cannot create dev shell in HOME'
  exit 1
fi

# check if flake.nix exists
if [ -f "flake.nix" ]; then
  read -p 'flake.nix already present, override? [y/N]' response
  
  case "$response" in
    "n"|"N"|"") 
      echo 'Not overriding'
    ;;
    "y"|"Y") 
      echo 'Overriding flake.nix'
      flake_init
    ;;
    *) 
      echo 'Invalid input, not overriding'
    ;;
  esac
else
  echo 'Creating flake.nix'
  touch flake.nix
  flake_init
fi

# check if .envrc exists
if [ -f ".envrc" ]; then
  read -p '.envrc already present, override? [y/N]' response
  
  case "$response" in
    "n"|"N"|"") 
      echo 'Not overriding'
    ;;
    "y"|"Y") 
      echo 'Overriding .envrc'
      flake_init
    ;;
    *) 
      echo 'Invalid input, not overriding'
    ;;
  esac
else
  echo 'Creating .envrc'
  touch .envrc
  envrc_init
fi
