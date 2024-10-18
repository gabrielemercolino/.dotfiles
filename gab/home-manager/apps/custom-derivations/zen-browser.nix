{ appimageTools, fetchurl, specific ? false }:
let
  name    = "zen";
  version = "1.0.1-a.10";

  kind = if specific then "specific" else "generic"; 
  specificHash = "sha256-pZfYZ0cfQUV8mcLKJKnVaRhyCPKVs/y84+tIWUdQnww=";
  genericHash  = "sha256-rvMDVDXEpsZk1CDMhS8b8QiM2hTYFMmkKt/uEk76Xrc=";
  
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
