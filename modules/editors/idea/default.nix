{
  self,
  lib,
  ...
}: {
  flake.homeModules.idea = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.editors.idea;
  in {
    options.gab.editors.idea = {
      enable = lib.mkEnableOption "idea community edition";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [self.packages.${pkgs.stdenv.hostPlatform}.idea];
    };
  };

  flake.homeModules.editors = _: {imports = [self.homeModules.idea];};

  perSystem = {pkgs, ...}: {
    packages.idea = pkgs.callPackage ./_package.nix {};
  };
}
