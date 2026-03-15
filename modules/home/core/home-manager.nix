{ config, ... }:
{
  flake.modules.homeManager = {
    home-manager =
      { user, ... }:
      {
        home = {
          stateVersion = "26.05";
          userName = user.name;
          homeDirectory = "/home/${user.name}";
        };

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
      };

    core.imports = [ config.flake.modules.homeManager.home-manager ];
  };
}
