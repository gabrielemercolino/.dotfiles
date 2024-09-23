{ 
  stdenv, 
  installShellFiles, 
  bashly,
  grim,
  slurp,
}:

stdenv.mkDerivation (finalAttrs: rec{
  name = "gab";
  version = "1.2";
  src = ./.;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ bashly slurp grim ];

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
