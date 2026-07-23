force=${args[--force]}
update=${args[--update]}

# --- config paths ---
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
HASH_DIR="$XDG_CONFIG_HOME/gab"
HASH_FILE="$HASH_DIR/nixpkgs_hash"

mkdir -p "$HASH_DIR"

# --- helpers ---

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
  new_hash=$(fetch_latest_rev)

  if [[ -z "$new_hash" ]]; then
    echo "could not check for update: no network?" >&2
    exit 1
  fi

  stored_hash=""
  [[ -f "$HASH_FILE" ]] && stored_hash=$(<"$HASH_FILE")

  # --- compare & optionally update stored hash ---
  if [[ "$new_hash" == "$stored_hash" ]]; then
    echo "nixpkgs already up to date (${new_hash})"
  else
    echo "current stored hash: ${stored_hash:-none}"
    echo "latest upstream:      ${new_hash}"
    read -rp "Update stored hash? [y/N] " answer

    case "$answer" in
      "y"|"Y")
        mkdir -p "$HASH_DIR"
        printf '%s\n' "$new_hash" > "$HASH_FILE"
        stored_hash="$new_hash"
        echo "stored hash updated to ${new_hash}"
        ;;
      *) ;;
    esac
  fi

  # --- now check flake.nix ---
  if [[ -f flake.nix ]]; then
    current_pin=$(extract_nixpkgs_pin flake.nix)

    if [[ -z "$current_pin" ]]; then
      echo "could not detect nixpkgs url in flake.nix (skipping)"
    elif [[ "$current_pin" == "$stored_hash" ]]; then
      echo "flake.nix already pinned to stored hash"
    else
      read -rp "Update flake.nix nixpkgs from ${current_pin} to ${stored_hash}? [y/N] " answer
      case "$answer" in
        "y"|"Y")
          sed -i "s|nixpkgs/${current_pin}|nixpkgs/${stored_hash}|g" flake.nix
          echo "flake.nix updated"
          ;;
        *) echo "skipping flake.nix patch" ;;
      esac
    fi
  fi

  exit 0
fi

# ====================================================================
#  NORMAL MODE  (gab dev)
# ====================================================================

# 1. Ensure a stored hash exists
if [[ ! -f "$HASH_FILE" ]]; then
  hash=$(fetch_latest_rev)

  if [[ -z "$hash" ]]; then
    echo "could not determine latest nixpkgs rev, use 'gab dev -u'" >&2
    exit 1
  fi

  echo "latest nixpkgs rev: ${hash}"
  read -rp "Save this hash? [Y/n] " answer

  case "$answer" in
    "n"|"N")
      echo "a pinned hash is required" >&2
      exit 1
      ;;
    *)
      mkdir -p "$HASH_DIR"
      printf '%s\n' "$hash" > "$HASH_FILE"
      ;;
  esac
fi

stored_hash=$(<"$HASH_FILE")

# 2. Create flake.nix
if create_if_allowed "flake.nix" "flake.tpl"; then
  sed -i "s/{{NIXPKGS_REV}}/${stored_hash}/g" flake.nix
fi

# 3. Create .envrc
create_if_allowed ".envrc" ".envrc.tpl"

echo
echo "Dev env ready"
