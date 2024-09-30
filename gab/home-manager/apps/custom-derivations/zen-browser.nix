{ appimageTools, fetchurl, specific ? false }:
let
  name    = "zen";
  version = "1.0.1-a.6";
  
  src = fetchurl {
    url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-${if specific then "specific" else "generic"}.AppImage";
    hash = "sha256-1Rho9F0gJUoTWcn5OTVfAJtgeyIhUU0n+pBdVP9n3iU=";
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
