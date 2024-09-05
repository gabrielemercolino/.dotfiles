delete_old=${args[--delete-old]}

TIMESPAN="7d"

# sudo is for system
# without sudo is for home-manager

if [[ $delete_old ]]; then
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
else
  sudo nix-collect-garbage --delete-older-than $TIMESPAN
  nix-collect-garbage --delete-older-than $TIMESPAN
fi
