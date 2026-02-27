{lib, ...}: {
  flake.homeModules.socials = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.socials.discord;
  in {
    options.gab.socials.discord = {
      enable = lib.mkEnableOption "discord";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [(pkgs.discord.override {withEquicord = true;})];
    };
  };
}
