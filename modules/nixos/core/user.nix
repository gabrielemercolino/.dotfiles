{ config, lib, ... }:
{
  flake.modules.nixos = {
    core.imports = [ config.flake.modules.nixos.user ];
    user =
      { user, ... }:
      {
        users.users.${user.name} = {
          isNormalUser = true;
          description = user.name;
          extraGroups = [ "wheel" ];
        };

        services.getty.autologinUser = lib.mkDefault user.name;
      };
  };
}
