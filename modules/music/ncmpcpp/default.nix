{
  self,
  lib,
  ...
}: {
  flake.homeModules.ncmpcpp = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.music.ncmpcpp;
  in {
    options.gab.music.ncmpcpp = {
      enable = lib.mkEnableOption "ncmpcpp";
    };

    config = lib.mkIf cfg.enable {
      programs.ncmpcpp = {
        enable = true;

        settings = import ./_settings.nix {inherit config pkgs;};
      };
    };
  };

  flake.homeModules.music = _: {imports = [self.homeModules.ncmpcpp];};
}
