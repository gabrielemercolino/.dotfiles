{ config, lib, ... }:
{
  flake.modules.nixos = {
    apps.imports = [ config.flake.modules.nixos.lact ];

    lact =
      { config, pkgs, ... }:
      let
        cfg = config.gab.apps.lact;
      in
      {
        options.gab.apps.lact = {
          enable = lib.mkEnableOption "lact";
        };

        config = lib.mkIf cfg.enable {
          environment.systemPackages = [ pkgs.lact ];

          ## lact needs its daemon to properly work
          systemd.services.lact = {
            enable = true;
            description = "AMDGPU Control Daemon";
            after = [ "multi-user.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig.ExecStart = "${pkgs.lact}/bin/lact daemon";
          };
        };
      };
  };
}
