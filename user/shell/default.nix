{ systemSettings, ... }:
{
  imports = [
    ./utility.nix
    (./. + ("/"+systemSettings.shell)+".nix")
  ];
}
