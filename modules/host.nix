{lib, ...}: {
  flake.nixosModules.host = {config, ...}: let
    cfg = config.gab.host;
  in {
    options.gab.host = with lib.types; {
      name = lib.mkOption {
        type = str;
        default = "nixos";
      };
    };

    config = {
      networking.hostName = cfg.name;
    };
  };
}
