{ self, lib, ... }:
{
  flake.modules.nixos = {
    services.imports = [ self.modules.nixos.ssh ];

    ssh =
      { config, pkgs, ... }:
      let
        cfg = config.gab.services.ssh;
      in
      {
        options.gab.services.ssh = {
          enable = lib.mkEnableOption "ssh";
        };

        config = lib.mkIf cfg.enable {
          services.openssh.enable = true;
        };
      };
  };
}
