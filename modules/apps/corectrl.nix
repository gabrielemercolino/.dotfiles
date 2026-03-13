{
  self,
  lib,
  ...
}: {
  flake.nixosModules.corectrl = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.corectrl;
  in {
    imports = [self.nixosModules.user];

    options.gab.apps.corectrl = {
      enable = lib.mkEnableOption "corectrl";
    };

    config = lib.mkIf cfg.enable {
      users.users.${config.gab.user.name}.extraGroups = ["corectrl"];

      environment.systemPackages = [pkgs.lm_sensors];

      programs.corectrl.enable = true;
    };
  };

  flake.nixosModules.apps = _: {imports = [self.nixosModules.corectrl];};
}
