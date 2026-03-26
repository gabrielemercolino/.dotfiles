{
  perSystem =
    { pkgs, ... }:
    {
      packages.gab = pkgs.stdenv.mkDerivation rec {
        name = "gab";
        src = ./.;

        nativeBuildInputs = with pkgs; [
          installShellFiles
          bashly
          makeWrapper
        ];

        buildInputs = with pkgs; [ nh ];

        buildPhase = ''
          bashly add completions
          bashly generate
          bashly add completions_script
        '';

        installPhase = ''
          mkdir -p $out/bin
          mkdir -p $out/share

          cp gab $out/bin/${name}
          cp -r templates $out/share/templates

          wrapProgram $out/bin/${name} \
            --prefix PATH : ${pkgs.nh}/bin \
            --set TEMPLATES_DIR "$out/share/templates"
        '';

        postInstall = ''
          installShellCompletion completions.bash
        '';
      };
    };
}
