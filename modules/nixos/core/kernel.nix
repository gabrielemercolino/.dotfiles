{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    mkDefault
    ;
  inherit (lib.types) str listOf;
in
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.kernel ];

    kernel =
      { config, pkgs, ... }:
      let
        cfg = config.gab.kernel;
      in
      {
        options.gab.kernel = {
          scx = {
            enable = mkEnableOption "scx";
            scheduler = mkOption {
              type = str;
              default = "scx_lavd";
            };
            args = mkOption {
              type = listOf str;
              default = [ "--performance" ];
            };
          };
        };

        config = {
          # cachyos kernel stuff
          nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

          nix.settings = rec {
            substituters = [ "https://attic.xuyh0120.win/lantian" ];
            trusted-substituters = substituters;
            trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
          };

          boot.kernelPackages = mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;

          services.scx = mkIf cfg.scx.enable {
            enable = true;
            scheduler = cfg.scx.scheduler;
            extraArgs = cfg.scx.args;
          };
        };
      };
  };
}
