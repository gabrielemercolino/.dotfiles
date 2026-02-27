{lib, ...}: {
  flake.nixosModules.apps = {config, ...}: let
    cfg = config.gab.apps.ssh;
  in {
    options.gab.apps.ssh = {
      enable = lib.mkEnableOption "ssh";
    };

    config = lib.mkIf cfg.enable {
      services.openssh.enable = true;
    };
  };
}
