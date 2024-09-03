delete_old=${args[--delete-old]}

TIMESPAN="30d"

if [[ $delete_old ]]; then
  # for system packages
  sudo nix-collect-garbage --delete-older-than $TIMESPAN
  # for home-manager
  nix-collect-garbage --delete-older-than $TIMESPAN
else
  nix-collect-garbage
fi
