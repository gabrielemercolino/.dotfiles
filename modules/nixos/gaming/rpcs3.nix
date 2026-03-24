{ config, lib, ... }:
{
  flake.modules.nixos = {
    gaming.imports = [ config.flake.modules.nixos.rpcs3 ];

    rpcs3 =
      { config, pkgs, ... }:
      let
        cfg = config.gab.gaming.rpcs3;
      in
      {
        options.gab.gaming.rpcs3 = {
          enable = lib.mkEnableOption "rpcs3";
        };

        config = lib.mkIf cfg.enable {
          environment.systemPackages = [ pkgs.rpcs3 ];
        };
      };
  };
}
