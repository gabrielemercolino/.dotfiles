filter=${args[filter]}
config=${args[config]}

case "$filter" in
  "both")
    sudo nixos-rebuild switch --flake ~/.dotfiles#${config}
    home-manager switch --flake ~/.dotfiles#${config}
  ;;
  "system")
    sudo nixos-rebuild switch --flake ~/.dotfiles#${config}
  ;;
  "home")
    home-manager switch --flake ~/.dotfiles#${config}
  ;;
esac
