delete_old=${args[--delete-old]}

if [[ $delete_old ]]; then
  sudo nix-collect-garbage --delete-older-than 30d
else
  nix-collect-garbage
fi
