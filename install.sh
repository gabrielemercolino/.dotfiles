echo "IMPORTANT"
echo "Remember to set the hardware configuration file in the desired profile (profiles/<name>/hardware-configuration.nix)"
echo "To generate it you can use:"
echo "    sudo nixos-generate-config --show-hardware-config"
echo "or just copy it from etc/nixos/hardware-configuration.nix"
echo ""

printf "Did you do it? [y/N]"
read -r proceed

case $proceed in
  "y");;
  "Y");;
  *)
    echo "Aborting install"
    exit 1
esac

echo "Please select which profile to install:"
echo "  - mini-pc"
echo "  - chromebook"
echo ""

printf "input: "
read -r profile

case $profile in
  "mini-pc");;
  "chromebook");;
  *)
    echo "Invalid input, aborting"
    exit 1
esac

sudo nixos-rebuild switch --flake ~/.dotfiles#"$profile"

nix run home-manager/master --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.dotfiles#"$profile"

clear

echo "Installation finished, you can reboot now"
