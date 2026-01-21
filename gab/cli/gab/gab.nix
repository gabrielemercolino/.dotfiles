{
  stdenv,
  installShellFiles,
  bashly,
  makeWrapper,
  nh,
}:
stdenv.mkDerivation rec {
  name = "gab";
  src = ./.;

  nativeBuildInputs = [
    installShellFiles
    bashly
    makeWrapper
  ];

  buildInputs = [nh];

  buildPhase = ''
    bashly add completions
    bashly generate
    bashly add completions_script
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp gab $out/bin/${name}
    wrapProgram $out/bin/${name} \
      --prefix PATH : ${nh}/bin
  '';

  postInstall = ''
    installShellCompletion completions.bash
  '';
}
