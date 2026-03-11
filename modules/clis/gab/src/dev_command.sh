flake_init() {
  cat > flake.nix << EOF
{
  description = "template dev flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];

      perSystem = { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
            # config.allowUnfree = true;
          };
        in {
          devShells.default = pkgs.mkShell {
            nativeBuildInputs = with pkgs; [];
            buildInputs = with pkgs; [];
            shellHook = "";
          };
        };
    };
}
EOF
}

envrc_init() {
  echo 'use flake' > .envrc
}

confirm_override() {
  local target="$1"
  local response

  read -rp "${target} already present, override? [y/N] " response
  case "${response}" in
    "y"|"Y") return 0 ;;
    *) return 1 ;;
  esac
}

handle_file() {
  local file="$1"
  local init_fn="$2"

  if [[ -f "$file" ]]; then
    if confirm_override "$file"; then
      echo "Overriding $file"
      "$init_fn"
    else
      echo "Skipping $file"
    fi
  else
    echo "Creating $file"
    "$init_fn"
  fi
}

if [[ "$PWD" == "$HOME" ]]; then
  echo "Cannot create dev shell in ${HOME}"
  exit 1
fi

handle_file "flake.nix" flake_init
handle_file ".envrc"    envrc_init
