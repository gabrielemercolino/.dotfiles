{ pkgs, background }:

pkgs.stdenv.mkDerivation {
  name = "sddm-theme";

  src = pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50176c3b34df29003726ef9708813d06271";
    sha256 = "036fxsa7m8ymmp3p40z671z163y6fcsa9a641lrxdrw225ssq5f3";
  };

  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm assets/background.jpg
    cp -r ${background} $out/assets/background.jpg
  '';
}

