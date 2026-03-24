{ self, lib, ... }:
{
  flake.modules.nixos = {
    gaming.imports = [ self.modules.nixos.lsfg ];

    lsfg =
      { config, pkgs, ... }:
      let
        cfg = config.gab.gaming.lsfg;
      in
      {
        options.gab.gaming.lsfg = {
          enable = lib.mkEnableOption "lsfg-vk[-ui]";
        };

        config = lib.mkIf cfg.enable {
          environment.systemPackages = [
            pkgs.lsfg-vk-ui
            pkgs.lsfg-vk
          ];
        };
      };
  };
}
