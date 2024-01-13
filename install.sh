#!/bin/bash

set -e

nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

sudo nixos-rebuild switch --flake ~/.dotfiles/

home-manager switch --flake ~/.dotfiles/
