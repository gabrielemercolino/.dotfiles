{lib, ...}:
with lib.types; {
  flake.nixosModules.user = {config, ...}: let
    cfg = config.gab.user;
  in {
    options.gab.user = {
      name = lib.mkOption {type = str;};
      autologin = lib.mkEnableOption "auto login" // {default = true;};
    };

    config = {
      users.users.${cfg.name} = {
        isNormalUser = true;
        description = cfg.name;
        extraGroups = ["wheel"];
      };

      services.getty.autologinUser = lib.mkIf cfg.autologin cfg.name;

      nix.settings.trusted-users = [cfg.name];
    };
  };

  flake.homeModules.user = {config, ...}: let
    cfg = config.gab.user;
  in {
    options.gab.user = {
      name = lib.mkOption {type = str;};
    };

    config = {
      home = {
        username = cfg.name;
        homeDirectory = "/home/${cfg.name}";
      };
    };
  };
}
