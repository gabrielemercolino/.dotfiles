{...}: {
  flake.nixosModules.gaming = {
    lib,
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.gaming.steam;
  in {
    options.gab.gaming = {
      steam.enable = lib.mkEnableOption "steam";
    };

    config = {
      boot.kernelModules = lib.optionals cfg.enable ["ntsync"];

      programs.steam = {
        enable = cfg.enable;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };
  };
}
