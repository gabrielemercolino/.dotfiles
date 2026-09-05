{ self, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ self.modules.homeManager.home-manager ];

    home-manager =
      { user, ... }:
      {
        home = {
          username = user.name;
          homeDirectory = "/home/${user.name}";
        };
      };
  };
}
