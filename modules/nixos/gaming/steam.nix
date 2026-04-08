{ self, lib, ... }:
{
  flake.modules.nixos = {
    gaming.imports = [ self.modules.nixos.steam ];

    steam =
      { config, pkgs, ... }:
      let
        cfg = config.gab.gaming.steam;
      in
      {
        options.gab.gaming.steam = {
          enable = lib.mkEnableOption "steam";
        };

        config = lib.mkIf cfg.enable {
          boot.kernelModules = [ "ntsync" ];

          programs.steam = {
            enable = true;
            extraCompatPackages = [ pkgs.proton-ge-bin ];
            extest.enable = true;
          };
        };
      };
  };
}
