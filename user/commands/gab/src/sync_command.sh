config=${args[config]}

sudo nixos-rebuild switch --flake ~/.dotfiles#${config}
home-manager switch --flake ~/.dotfiles#${config}
