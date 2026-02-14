{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.music;
in {
  options.gab.apps.music = {
    ncmpcpp.enable = lib.mkEnableOption "ncmpcpp";
  };

  config = {
    programs.ncmpcpp = {
      inherit (cfg.ncmpcpp) enable;

      settings = import ./_settings.nix {inherit config pkgs;};
    };
  };
}
