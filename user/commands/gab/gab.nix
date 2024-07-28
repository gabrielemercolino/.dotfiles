{ 
  stdenv, 
  bashly, 
  installShellFiles, 
}:

stdenv.mkDerivation (finalAttrs: {
  name = "gab";

  src = ./.;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ bashly ];

  buildPhase = ''
    bashly add completions
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
