#!/bin/sh

sudo nixos-generate-config --show-hardware-config > ./system/hardware-configuration.nix

echo "Please select which profile to install:"
echo "  - mini-pc"
echo "  - chromebook"
echo ""

read -p "input: " profile

case $profile in
  "mini-pc");;
  "chromebook");;
  *)
    echo "Invalid input, aborting"
    exit 1
esac

sudo nixos-rebuild switch --flake ~/.dotfiles#$profile

nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.dotfiles#$profile
