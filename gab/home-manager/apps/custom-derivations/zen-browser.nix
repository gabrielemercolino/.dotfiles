{
  appimageTools,
  fetchurl,
  stdenv,
}:
let
  name = "zen";
  version = "1.0.2-b.4";

  getUrl =
    system:
    if system == "x86_64-linux" then
      "https://github.com/zen-browser/desktop/releases/download/${version}/zen-x86_64.AppImage"
    else if system == "aarch64-linux" then
      "https://github.com/zen-browser/desktop/releases/download/${version}/zen-aarch64.AppImage"
    else
      throw "Unsupported architecture: ${system}";

  getHash =
    system:
    if system == "x86_64-linux" then
      "sha256-lHqNAfr0nDR8pV3egKzNXn5DJn9W0vJqiV1WJLG+U34="
    else if system == "aarch64-linux" then
      "sha256-jU0/kXZz8nR67MtCM1wez6ShqGEarUqZEb47OOH3seo="
    else
      throw "Unsupported architecture: ${system}";

  src = fetchurl {
    url = getUrl stdenv.system;
    hash = getHash stdenv.system;
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

  meta.platforms = [
    "x86_64-linux"
    "aarch64-linux"
  ];

}
