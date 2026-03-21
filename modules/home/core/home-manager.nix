{ config, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ config.flake.modules.homeManager.home-manager ];

    home-manager =
      { user, ... }:
      {
        home = {
          stateVersion = "26.05";
          username = user.name;
          homeDirectory = "/home/${user.name}";
        };

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
      };
  };
}
