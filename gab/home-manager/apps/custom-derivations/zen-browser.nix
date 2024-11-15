{
  appimageTools,
  fetchurl,
  specific ? false,
}:
let
  name = "zen";
  version = "1.0.1-a.19";

  kind = if specific then "specific" else "generic";
  specificHash = "sha256-qAPZ4VyVmeZLRfL0kPHF75zyrSUFHKQUSUcpYKs3jk8=";
  genericHash = "sha256-fubz5D1rKjapKbrIQ5yYuBnqn4ppvbJNgLh2Gmgl/hM=";

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
