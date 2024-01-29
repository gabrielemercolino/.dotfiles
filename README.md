## Install home-manager:

```sh
sudo nixos-generate-config --show-hardware-config >> ./system/hardware-configuration.nix
```

```sh
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install # If it doesn't work reboot
```

## Update system config
```sh
sudo nixos-rebuild switch --flake ~/.dotfiles/
```

## Update home-manager config
```sh
home-manager switch --flake ~/.dotfiles/
```
