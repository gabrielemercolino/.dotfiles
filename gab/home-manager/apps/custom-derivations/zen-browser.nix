{ appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  name = "zen-browser";
  version = "1.0.1-a.5";

  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-generic.AppImage";
    hash = "sha256-j+z3TQCZ8O74RgQHAKTcE/H8c90LvsBgn/6fvyjKoFU=";
  };
}
