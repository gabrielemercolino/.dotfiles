{
  self,
  lib,
  ...
}: {
  flake.nixosModules.suyu = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.gaming.suyu;
  in {
    options.gab.gaming.suyu = {
      enable = lib.mkEnableOption "suyu";
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.suyu];
    };
  };

  flake.nixosModules.gaming = _: {imports = [self.nixosModules.suyu];};

  perSystem = {pkgs, ...}: {
    packages.suyu = pkgs.callPackage ./_package.nix {};
  };
}
