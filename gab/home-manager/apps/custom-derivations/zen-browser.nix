{ appimageTools, fetchurl, specific ? false }:
let
  name    = "zen";
  version = "1.0.1-a.7";

  kind = if specific then "specific" else "generic"; 
  specificHash = "sha256-Za8p4lp5S+XzeW0nYMlrX7ahdwwuyNDwDtvL/uYwUqc=";
  genericHash  = "sha256-sl9z32PirO5wyQRn4XG9s9p9w8xFbgwmnLUmTMNfJwQ=";
  
  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-${kind}.AppImage";
    hash = if specific then specificHash else genericHash;
  };

  appimageContents = appimageTools.extract { inherit name version src; };
in
appimageTools.wrapType2 {
  inherit name version src;
  
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/zen.desktop $out/share/applications/zen.desktop
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/128x128/apps/zen.png \
      $out/share/icons/hicolor/128x128/apps/zen.png
  '';
}
