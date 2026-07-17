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

        extraInstallCommands = ''
          mv $out/bin/cisco-packet-tracer $out/bin/packettracer9
        '';

        meta = {
          mainProgram = "packettracer9";
          platforms = [ "x86_64-linux" ];
        };
      };
  };
}
