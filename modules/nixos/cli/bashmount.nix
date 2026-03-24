{ self, lib, ... }:
{
  flake.modules.nixos = {
    cli.imports = [ self.modules.nixos.bashmount ];
    bashmount =
      {
        config,
        pkgs,
        ...
      }:
      let
        cfg = config.gab.cli.bashmount;
      in
      {
        options.gab.cli.bashmount = {
          enable = lib.mkEnableOption "bashmount (with udisk2)";
        };

        config = lib.mkIf cfg.enable {
          environment.systemPackages = [ pkgs.bashmount ];

          services.udisks2.enable = true;
        };
      };
  };
}
