{
  ags-bar,
  pkgs,
  config,
}: let
  colors = config.lib.stylix.colors.withHashtag;
  inherit (config.stylix) fonts;
  system = pkgs.stdenv.hostPlatform.system;
in
  ags-bar.packages.${system}.default.override {
    commands.lock = "${pkgs.swaylock-effects}/bin/swaylock";
    fonts = [fonts.monospace];
    colors.base16 = colors;
  }
