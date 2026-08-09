force=${args[--force]}
update=${args[--update]}

# --- config paths ---
GAB_DOTFILES_DIR="${GAB_DOTFILES_DIR:-$HOME/.dotfiles}"
DOTFILES_FLAKE="$GAB_DOTFILES_DIR/flake.nix"

# --- helpers ---

die() {
  echo "error: $1" >&2
  exit 1
}

fetch_latest_rev() {
  echo "fetching latest nixpkgs rev..." >&2
  nix flake metadata github:nixos/nixpkgs/nixpkgs-unstable --json 2>/dev/null \
    | grep -oP '"rev":\s*"\K[^"]+'
}

confirm_overwrite() {
  local file="$1"
  [[ ! -e "$file" ]] && return 0
  read -rp "'$file' already present, override? [y/N] " answer
  case "$answer" in
    "y"|"Y") rm "$file"; return 0 ;;
    *)       return 1 ;;
  esac
}

create_from_template() {
  local src="$1" dst="$2"
  echo "creating $dst"
  cp "$TEMPLATES_DIR/dev/$src" "$dst"
  chmod +w "$dst"
}

create_if_allowed() {
  local file="$1" src="$2"
  if [[ $force ]]; then
    rm -f "$file"
  elif ! confirm_overwrite "$file"; then
    echo "skipping $file"
    return 1
  fi
  create_from_template "$src" "$file"
}

extract_nixpkgs_pin() {
  grep -oP '(?:github:nixos/)?nixpkgs/\K[^";]+' "$1" 2>/dev/null || true
}

# ====================================================================
#  UPDATE MODE  (gab dev -u)
# ====================================================================
if [[ $update ]]; then
  # Determine which flake to inspect
  if [[ "$(realpath "$PWD")" == "$(realpath "$GAB_DOTFILES_DIR")" ]]; then
    target="$DOTFILES_FLAKE"
    new_hash=$(fetch_latest_rev)
  elif [[ -f flake.nix ]]; then
    target="flake.nix"
    # Use dotfiles pin as reference, don't fetch
    [[ ! -f "$DOTFILES_FLAKE" ]] && die "$DOTFILES_FLAKE not found"
    new_hash=$(extract_nixpkgs_pin "$DOTFILES_FLAKE")
  else
    echo "no flake.nix found -- nothing to update" >&2
    exit 1
  fi

  [[ -z "$new_hash" ]] && die "could not determine target nixpkgs rev"

  current_pin=$(extract_nixpkgs_pin "$target")

  [[ -z "$current_pin" ]] && die "could not detect nixpkgs url in $target"

  if [[ "$current_pin" == "$new_hash" ]]; then
    echo "nixpkgs already up to date (${new_hash})"
  else
    echo "current: ${current_pin}"
    echo "latest:  ${new_hash}"
    read -rp "Update nixpkgs in flake.nix? [y/N] " answer

    case "$answer" in
      "y"|"Y")
        sed -i "s|nixpkgs/${current_pin}|nixpkgs/${new_hash}|g" "$target"
        echo "updated nixpkgs pin in flake.nix"
        ;;
      *) ;;
    esac
  fi

  exit 0
fi

# ====================================================================
#  NORMAL MODE  (gab dev)
# ====================================================================

[[ ! -f "$DOTFILES_FLAKE" ]] && die "$DOTFILES_FLAKE not found"

stored_hash=$(extract_nixpkgs_pin "$DOTFILES_FLAKE")

[[ -z "$stored_hash" ]] && die "could not detect nixpkgs url in $DOTFILES_FLAKE"

echo "using nixpkgs rev: ${stored_hash}"

# Create flake.nix
if create_if_allowed "flake.nix" "flake.tpl"; then
  sed -i "s/{{NIXPKGS_REV}}/${stored_hash}/g" flake.nix
fi

# Create .envrc
create_if_allowed ".envrc" ".envrc.tpl"

echo
echo "Dev env ready"
