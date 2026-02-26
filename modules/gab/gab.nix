{self, ...}: {
  flake.homeModules.gab = {pkgs, ...}: let
    system = pkgs.stdenv.hostPlatform.system;
  in {
    home.packages = [self.packages.${system}.gab];
  };

  perSystem = {pkgs, ...}: {
    packages.gab = pkgs.stdenv.mkDerivation rec {
      name = "gab";
      src = ./.;

      nativeBuildInputs = with pkgs; [
        installShellFiles
        bashly
        makeWrapper
      ];

      buildInputs = with pkgs; [nh];

      buildPhase = ''
        bashly add completions
        bashly generate
        bashly add completions_script
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp gab $out/bin/${name}
        wrapProgram $out/bin/${name} \
          --prefix PATH : ${pkgs.nh}/bin
      '';

      postInstall = ''
        installShellCompletion completions.bash
      '';
    };
  };
}
