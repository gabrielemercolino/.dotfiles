{ lib, ... }:

# Only definitions here

{
  imports = [
    ./mangohud.nix
  ];

  options.gab.gaming = {
    mangohud = lib.mkEnableOption "mangohud";
  };
}
