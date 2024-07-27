{ 
  stdenv, 
  bashly, 
  installShellFiles, 
  makeWrapper
}:

stdenv.mkDerivation (finalAttrs: {
  name = "gab";

  src = ./.;

  nativeBuildInputs = [ installShellFiles makeWrapper ];

  buildInputs = [ bashly ];

  buildPhase = ''
    bashly generate
    bashly add completions_script
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gab $out/bin/gab
  '';

  postInstall = ''
    installShellCompletion completions.bash
  '';
})
