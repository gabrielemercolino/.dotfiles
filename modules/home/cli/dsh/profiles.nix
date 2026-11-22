{ lib, inputs, ... }:
{
  flake.modules.homeManager = {
    dsh =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.dsh;
        system = pkgs.stdenv.hostPlatform.system;
      in
      {
        config = lib.mkIf cfg.enable {
          # `@deepseek-ai/dsh-base` is implicit: these bundles layer on top of
          # it. `dsh --profile nix-web` / `nix-tui` boots either surface.
          # Bundles come prebuilt from their locked nixpkgs, so they hit the
          # deepseek-harness-nix cache.
          programs.dsh.profiles = {
            web.bundles = [ inputs.deepseek-harness.legacyPackages.${system}.bundles.web-app ];
            tui.bundles = [ inputs.deepseek-harness.legacyPackages.${system}.bundles.tui ];
          };
        };
      };
  };
}
