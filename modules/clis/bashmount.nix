{
  self,
  lib,
  ...
}: {
  flake.nixosModules.bashmount = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.bashmount;
  in {
    options.gab.apps.bashmount = {
      enable = lib.mkEnableOption "bashmount (with udisk2)";
    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [pkgs.bashmount];

      services.udisks2.enable = true;
    };
  };

  flake.nixosModules.clis = _: {imports = [self.nixosModules.bashmount];};
}
