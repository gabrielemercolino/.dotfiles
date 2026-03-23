{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../gab/home-manager
  ];

  xdg =
    let
      xdg = import ./xdg.nix { inherit config lib pkgs; };
    in
    {
      enable = true;
      desktopEntries = xdg.desktopEntries;
      mimeApps = {
        enable = true;
        defaultApplications = xdg.defaultApplications;
      };
    };
  };
}
