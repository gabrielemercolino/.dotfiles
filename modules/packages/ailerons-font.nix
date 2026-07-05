{
  perSystem =
    { pkgs, ... }:
    {
      packages.ailerons-font = pkgs.stdenv.mkDerivation {
        pname = "ailerons-font";
        version = "1.0";

        dontBuild = true;

        src = pkgs.fetchurl {
          url = "https://font.download/dl/font/ailerons.zip";
          hash = "sha256-2HgKWvCofGe0M29XxIXssg/uHP7cpkNDIJYHq7zyfdc=";
        };

        nativeBuildInputs = [ pkgs.unzip ];

        unpackPhase = ''
          unzip $src
        '';

        installPhase = ''
          mkdir -p $out/share/fonts/opentype
          cp Ailerons-Typeface.otf $out/share/fonts/opentype/
        '';
      };
    };
}
