{
  self,
  lib,
  ...
}: {
  flake.nixosModules.rpcs3 = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.gaming;
  in {
    options.gab.gaming.rpcs3 = {
      enable = lib.mkEnableOption "rpcs3";
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [pkgs.rpcs3];
    };
  };

  flake.nixosModules.gaming = _: {imports = [self.nixosModules.rpcs3];};
}
