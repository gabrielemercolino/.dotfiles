{ ... }:

{
  imports = [
    ./logind.nix    # for disabling power button
    ./getty.nix     # for enabling user auto login
    ./openssh.nix   # for enabling ssh
    ./bluetooth.nix # for enabling bluetooth
  ];
}
