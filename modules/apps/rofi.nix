{
  self,
  lib,
  ...
}: {
  flake.homeModules.rofi = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.rofi;
  in {
    options.gab.apps.rofi = {
      enable = lib.mkEnableOption "rofi";
    };

    config = lib.mkIf cfg.enable {
      programs.rofi = {
        enable = true;

        extraConfig = {
          modi = "drun";
          show-icons = true;
          icon-theme = "WhiteSur";
          display-drun = "run";
          drun-display-format = "{name}";
        };
      };
    };
  };

  flake.homeModules.apps = _: {imports = [self.homeModules.rofi];};
}
