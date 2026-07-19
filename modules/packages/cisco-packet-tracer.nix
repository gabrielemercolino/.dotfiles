{
  perSystem = { pkgs, ... }: {
    packages.cisco-packet-tracer =
      let
        version = "9.0.0";

        appimage = pkgs.stdenvNoCC.mkDerivation {
          pname = "cisco-packet-tracer-appimage";
          inherit version;

          src = pkgs.fetchurl {
            url = "https://archive.org/download/packettracer900/CiscoPacketTracer_900_Ubuntu_64bit.deb";
            hash = "sha256-3ZrA1Mf8N9y2j2J/18fm+m1CAMFEklJuVhi5vRcu2SA=";
          };

          nativeBuildInputs = [ pkgs.dpkg ];

          installPhase = ''
            runHook preInstall
            cp opt/pt/packettracer.AppImage $out
            runHook postInstall
          '';
        };
      in
      pkgs.appimageTools.wrapType2 {
        pname = "cisco-packet-tracer";
        inherit version;

        src = appimage;

        extraPkgs = _: [
          pkgs.libpng
          pkgs.libxkbfile
        ];

        extraBwrapArgs = [ "--setenv QT_QPA_PLATFORM xcb" ];

        extraInstallCommands =
          let
            contents = pkgs.appimageTools.extract {
              pname = "cisco-packet-tracer";
              inherit version;
              src = appimage;
            };
          in
          ''
            mv $out/bin/cisco-packet-tracer $out/bin/packettracer9

            install -Dm444 ${contents}/CiscoPacketTracer-9.0.0.desktop $out/share/applications/cisco-packet-tracer-9.desktop
            substituteInPlace $out/share/applications/* \
              --replace-fail "Exec=@EXEC_PATH@" "Exec=packettracer9" \
              --replace-fail "Icon=app" "Icon=cisco-packet-tracer-9"

            install -Dm444 ${contents}/usr/share/icons/hicolor/48x48/apps/app.png $out/share/icons/hicolor/48x48/apps/cisco-packet-tracer-9.png
            cp -r ${contents}/usr/share/icons/gnome/48x48/mimetypes $out/share/icons/hicolor/48x48/

            for desktop in $out/share/applications/*.desktop; do
              sed -i '/^\[Desktop Entry\]/a StartupWMClass=PacketTracer' "$desktop"
            done
          '';

        meta = {
          mainProgram = "packettracer9";
          platforms = [ "x86_64-linux" ];
        };
      };
  };
}
