{ inputs, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    { config, pkgs, ... }:
    let
      cfg = config.gab.wm.hyprland;
    in
    {
      imports = [ inputs.ags-bar.homeManagerModules.default ];

      config = lib.mkIf cfg.enable {
        programs = {
          ghostty.enable = true;

          ags-bar = {
            enable = true;
            systemd.enable = true;
          };
        };
      };
    };
}
