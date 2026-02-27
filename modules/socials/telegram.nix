{lib, ...}: {
  flake.homeModules.socials = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.socials.telegram;
  in {
    options.gab.socials.telegram = {
      enable = lib.mkEnableOption "telegram desktop";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [pkgs.telegram-desktop];
    };
  };
}
