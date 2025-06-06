{
  appimageTools,
  fetchurl,
}: let
  pname = "suyu";
  version = "0.0.3";

  src = fetchurl {
    url = "https://git.suyu.dev/suyu/suyu/releases/download/v${version}/Suyu-Linux_x86_64.AppImage";
    hash = "sha256-26sWhTvB6K1i/K3fmwYg5pDIUi+7xs3dz8yVj5q7H0c=";
  };

  appimageContents = appimageTools.extract {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/dev.suyu_emu.suyu.desktop $out/share/applications/dev.suyu_emu.suyu.desktop
      install -m 444 -D ${appimageContents}/dev.suyu_emu.suyu.svg \
        $out/share/icons/hicolor/128x128/apps/dev.suyu_emu.suyu.svg
    '';
  }
