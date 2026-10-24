{
  perSystem =
    { pkgs, ... }:
    {
      packages.agentmemory =
        let
          version = "0.9.30";
          iiiVersion = "0.22.1";

          # Prebuilt dynamically-linked Rust binary from the iii-hq/iii GitHub
          # release. autoPatchelfHook rewrites its interpreter/RPATH to NixOS'
          # glibc, so it can run outside a container.
          iii = pkgs.stdenv.mkDerivation {
            pname = "iii-engine";
            version = iiiVersion;
            src = pkgs.fetchurl {
              url = "https://github.com/iii-hq/iii/releases/download/iii%2Fv${iiiVersion}/iii-x86_64-unknown-linux-gnu.tar.gz";
              hash = "sha256-NNS9LsGHPmEUu4Nr59ucs/QQ0NYzU9JAkX8LycMN8Ts=";
            };
            nativeBuildInputs = [ pkgs.autoPatchelfHook ];
            buildInputs = [
              pkgs.glibc
              pkgs.libgcc
            ];
            unpackPhase = "tar -xzf $src";
            installPhase = "install -Dm755 iii $out/bin/iii";
          };

          src = pkgs.fetchurl {
            url = "https://registry.npmjs.org/@agentmemory/agentmemory/-/agentmemory-${version}.tgz";
            hash = "sha256-QU7FKhikaKDdetNtGm3osAv7NeHO+q5DfrdKveAmc18=";
          };
        in
        pkgs.buildNpmPackage {
          pname = "agentmemory";
          inherit version src;
          npmDepsHash = "sha256-RHnJezJh8i0jb/KwkfGGYtsj/1sM6zpzymjmD4RjxYw=";

          # dist/ is prebuilt; tsdown rebuild would only pull in devDeps.
          dontNpmBuild = true;
          # Optional deps (@huggingface/transformers, onnxruntime-node,
          # @node-rs/jieba) are only needed for local embeddings / CJK
          # tokenization and would run network install scripts during build.
          npmFlags = [
            "--omit=optional"
            "--ignore-scripts"
          ];

          postPatch = "cp ${./package-lock.json} package-lock.json";

          nativeBuildInputs = [ pkgs.makeWrapper ];
          postInstall = ''
            wrapProgram $out/bin/agentmemory \
              --prefix PATH : ${iii}/bin
          '';

          meta = {
            description = "Persistent memory for AI coding agents, powered by iii-engine";
            homepage = "https://github.com/rohitg00/agentmemory";
            license = pkgs.lib.licenses.asl20;
            mainProgram = "agentmemory";
            platforms = [ "x86_64-linux" ];
          };
        };
    };
}
