{ pkgs, stdenv }:

let
  mkExtension =
    {
      name,
      src,
      targetDir,
    }:
    stdenv.mkDerivation rec {
      inherit name src;

      passthru.targetDir = targetDir;

      installPhase = ''
        mkdir -p $out/share/${name}
        ln -s $src/* $out/share/${name}
      '';
    };
in
{
  lsp = mkExtension {
    name = "lite-xl-lsp";
    src = pkgs.fetchFromGitHub {
      owner = "lite-xl";
      repo = "lite-xl-lsp";
      rev = "master";
      sha256 = "sha256-IOjQvWKrt/jUFPCU7T8l8mBSWjYn2CqfVQGVZr9NOTg=";
    };
    targetDir = "lite-xl/plugins/lsp";
  };

  widgets = mkExtension {
    name = "lite-xl-widgets";
    src = pkgs.fetchFromGitHub {
      owner = "lite-xl";
      repo = "lite-xl-widgets";
      rev = "master";
      sha256 = "sha256-NTQTEt2QiexQbx1CKYF+hGZxtqAFdNrwdl+TznGlUfU=";
    };
    targetDir = "lite-xl/libraries/widget";
  };

}
