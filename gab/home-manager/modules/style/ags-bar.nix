{config, ...}: {
  programs.ags-bar = let
    inherit (config.lib.stylix) colors;
    inherit (config.stylix) fonts;
  in {
    fonts = [fonts.monospace];
    colors.base16 = colors.withHashtag;
  };
}
