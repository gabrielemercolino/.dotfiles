{
  stdenv,
  installShellFiles,
  bashly,
}:

stdenv.mkDerivation (finalAttrs: rec {
  name = "gab";
  version = "1.3.2";
  src = ./.;

  nativeBuildInputs = [
    installShellFiles
    bashly
  ];

  buildInputs = [ ];

  buildPhase = ''
    bashly add completions
    bashly generate
    bashly add completions_script
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gab $out/bin/${name}
  '';

  postInstall = ''
    installShellCompletion completions.bash
  '';
})
