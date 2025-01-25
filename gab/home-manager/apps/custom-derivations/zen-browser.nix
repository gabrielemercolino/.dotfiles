{
  appimageTools,
  fetchurl,
  stdenv,
}: let
  pname = "zen";
  version = "1.0.2-b.5";

  getUrl = system:
    if system == "x86_64-linux"
    then "https://github.com/zen-browser/desktop/releases/download/${version}/zen-x86_64.AppImage"
    else if system == "aarch64-linux"
    then "https://github.com/zen-browser/desktop/releases/download/${version}/zen-aarch64.AppImage"
    else throw "Unsupported architecture: ${system}";

  /*
  snippet
  nix-prefetch-url https://github.com/zen-browser/desktop/releases/download/$version/zen-aarch64.AppImage
  nix hash convert --hash-algo sha256 $hash
  */
  getHash = system:
    if system == "x86_64-linux"
    then "sha256-faJzPHtjE3Q+9WpPm1Lip4f7RJQrhWdTU+MFaCXy2Xg="
    else if system == "aarch64-linux"
    then "sha256-mKr+6CGG/KgHBylOxZBEmRdJv+rEfICtf1i164dKJIw="
    else throw "Unsupported architecture: ${system}";

  src = fetchurl {
    url = getUrl stdenv.system;
    hash = getHash stdenv.system;
  };

  appimageContents = appimageTools.extract {
    inherit version src pname;
  };
in
  appimageTools.wrapType2 {
    inherit version src pname;

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
