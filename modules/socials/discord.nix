{
  self,
  lib,
  ...
}: {
  flake.homeModules.discord = {
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

  flake.homeModules.socials = _: {imports = [self.homeModules.discord];};
}
