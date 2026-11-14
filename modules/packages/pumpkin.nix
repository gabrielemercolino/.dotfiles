{
  perSystem =
    { pkgs, ... }:
    let
      version = "0.2.0+26.3-26.51";
    in
    {
      # Upstream release binary instead of pkgs.pumpkin: the nixpkgs package is
      # missing pkg-config/zstd, so zstd-sys' build script fails, and no build of
      # it is available from cache.nixos.org (checked: neither the pinned nor the
      # fixed master output has a narinfo). The musl asset is statically linked,
      # so it needs no patchelf.
      packages.pumpkin = pkgs.stdenvNoCC.mkDerivation {
        pname = "pumpkin";
        inherit version;

        src = pkgs.fetchurl {
          url = "https://github.com/Pumpkin-MC/Pumpkin/releases/download/${version}/pumpkin-X64-Linux-musl";
          hash = "sha256-eY/BruTr4AXwKbfLcUQGT3fZJ8UsQXVU90vTJd5AC2U=";
        };

        dontUnpack = true;

        installPhase = ''
          runHook preInstall
          install -Dm755 $src $out/bin/pumpkin
          runHook postInstall
        '';

        meta = {
          description = "Minecraft server built entirely in Rust";
          homepage = "https://pumpkinmc.org/";
          license = pkgs.lib.licenses.gpl3Only;
          mainProgram = "pumpkin";
          platforms = [ "x86_64-linux" ];
          sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
        };
      };
    };
}
