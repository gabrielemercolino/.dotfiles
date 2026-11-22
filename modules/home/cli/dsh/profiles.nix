{ lib, inputs, ... }:
{
  flake.modules.homeManager = {
    dsh =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.dsh;
        system = pkgs.stdenv.hostPlatform.system;

        # The footer's dollar cell. A dsh bundle is a package whose
        # `nix-support/dsh-bundles.json` names the package root; the profile
        # links that root into its own `node_modules`, which is how the loader
        # finds the row the patch inserts.
        costUsd = pkgs.stdenvNoCC.mkDerivation {
          pname = "dsh-cost-usd";
          version = "0.1.0";
          src = ./cost-usd;

          dontBuild = true;
          dontConfigure = true;

          installPhase = ''
            runHook preInstall
            packageRoot="$out/lib/node_modules/dsh-cost-usd"
            mkdir -p "$packageRoot" "$out/nix-support"
            cp -R . "$packageRoot"
            chmod -R u+w "$packageRoot"
            printf '{"schema":1,"bundles":[{"name":"dsh-cost-usd","version":"0.1.0","patch":"./cordis.patch.yml","packageRoot":"%s"}]}\n' \
              "$packageRoot" > "$out/nix-support/dsh-bundles.json"
            runHook postInstall
          '';

          meta.description = "US-dollar session cost field for the dsh-tui footer";

          passthru = {
            dshBundle = true;
            dshBundleHelper = "buildDshBundle";
            runtimeDeps = [ ];
          };
        };
      in
      {
        config = lib.mkIf cfg.enable {
          # `@deepseek-ai/dsh-base` is implicit: these bundles layer on top of
          # it. `dsh --profile nix-web` / `nix-tui` boots either surface.
          # Bundles come prebuilt from their locked nixpkgs, so they hit the
          # deepseek-harness-nix cache.
          programs.dsh.profiles = {
            web.bundles = [ inputs.deepseek-harness.legacyPackages.${system}.bundles.web-app ];
            tui.bundles = [
              inputs.deepseek-harness.legacyPackages.${system}.bundles.tui
              costUsd
            ];
          };
        };
      };
  };
}
