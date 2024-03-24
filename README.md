# Dotfiles

These are my dotfiles for NisOS

## Installation

Before installing you should take a look at [flake.nix](flake.nix) and change the setting as you need.

Also, if you decide to clone the repo in a different location as `~/.dotfiles` you have to follow the manual installation method

```sh
nix-shell -p git    # ensure you have git
cd 
git clone git@github.com:gabrielemercolino/.dotfiles.git
cd .dotfiles/
./install.sh
```

Or manually, after cloning and cd into it

```sh
# you could also copy the already existing hardware config with
# cp /etc/nixos/hardware-configuration.nix ./system/hardware-configuration.nix
sudo nixos-generate-config --show-hardware-config > ./system/hardware-configuration.nix

sudo nixos-rebuild switch --flake .#system

nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#user
```

## Credits

| Config   | Link |
| :------: | :----: |
| Base     |[librephoenix](https://github.com/librephoenix/nixos-config)
| Waybar   |[sameeul-haque](https://github.com/sameemul-haque/dotfiles)