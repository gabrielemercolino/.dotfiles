delete_old=${args[--delete-old]}

TIMESPAN="7d"

# sudo is for system
# without sudo is for home-manager

if [[ $delete_old ]]; then
  sudo nix-collect-garbage --quiet -d
  nix-collect-garbage --quiet -d
else
  sudo nix-collect-garbage --quiet --delete-older-than $TIMESPAN
  nix-collect-garbage --quiet --delete-older-than $TIMESPAN
fi
