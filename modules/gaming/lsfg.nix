{
  self,
  lib,
  ...
}: {
  flake.nixosModules.lsfg = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.gaming.lsfg;
  in {
    options.gab.gaming.lsfg = {
      enable = lib.mkEnableOption "lsfg-vk[-ui]";
    };

    config = cfg.enable {
      environment.systemPackages = [pkgs.lsfg-vk-ui pkgs.lsfg-vk];
    };
  };

  flake.nixosModules.gaming = _: {imports = [self.nixosModules.lsfg];};
}
