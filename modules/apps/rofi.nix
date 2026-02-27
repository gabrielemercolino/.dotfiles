{lib, ...}: {
  flake.homeModules.apps = {
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
}
