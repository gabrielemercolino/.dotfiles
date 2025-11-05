# Dotfiles

These are my dotfiles for NixOS

## Installation

Before installing you should take a look at [flake.nix](flake.nix)
and change the setting as you need.

Also, if you decide to clone the repo in a different location as `~/.dotfiles`
you have to follow the manual installation method

```sh
nix shell nixpkgs#git    # ensure you have git
cd
git clone git@github.com:gabrielemercolino/.dotfiles.git
cd .dotfiles/
./install.sh
```

Or manually, after cloning and cd into it

```sh
# you could also copy the already existing hardware config with
# cp /etc/nixos/hardware-configuration.nix ./profiles/mini-pc/hardware-configuration.nix
sudo nixos-generate-config --show-hardware-config > ./profiles/mini-pc/hardware-configuration.nix

# you need to check what profiles exist
sudo nixos-rebuild switch --flake .#mini-pc

nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake .#mini-pc
```

## Credits

- [librephoenix](https://github.com/librephoenix/nixos-config)
- [sameeul-haque](https://github.com/sameemul-haque/dotfiles)
- [brunoanesio](https://github.com/brunoanesio/waybar-config)
