{config, ...}: let
  cfg = config.gab.gaming;
in {
  imports = [
    ./mangohud.nix
  ];

  options.gab.gaming = {
  };

  config = {
  };
}
