force=${args[--force]}

confirm_overwrite() {
  local file="$1"

  if [[ ! -e "$file" ]]; then
    return 0
  fi

  read -rp "'$file' already present, override? [y/N] " answer

  case "$answer" in
    "y"|"Y")
      rm "$file"
      return 0
      ;;
    *)
      echo "aborting"
      exit 0
      ;;
  esac
}

if [[ $force ]]; then
  rm -f flake.nix .envrc
else
  confirm_overwrite "flake.nix"
  confirm_overwrite ".envrc"
fi

echo "creating flake.nix"
cp "$TEMPLATES_DIR/dev/flake.tpl" flake.nix
chmod +w flake.nix

echo "creating .envrc"
cp "$TEMPLATES_DIR/dev/.envrc.tpl" .envrc
chmod +w .envrc

echo
echo "Dev env ready"
