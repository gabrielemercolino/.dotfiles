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

  mkSingleScriptExtension =
    {
      name,
      src,
      targetDir,
    }:
    stdenv.mkDerivation rec {
      inherit name src;

      passthru.targetDir = targetDir;

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out/share/${name}
        ln -s $src $out/share/${name}/init.lua
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

  autoinsert = mkSingleScriptExtension {
    name = "autoinsert";
    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lite-xl/lite-xl-plugins/refs/heads/master/plugins/autoinsert.lua";
      sha256 = "sha256-qbWsR0L3Fb3pVVe9BQ40NffUpiY7IXXxJ6J1nF//WBk=";
    };
    targetDir = "lite-xl/plugins/autoinsert";
  };

}
