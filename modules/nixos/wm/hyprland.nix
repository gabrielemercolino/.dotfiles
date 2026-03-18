{
  config,
  lib,
  ...
}:
let
  inherit (config.flake.modules) nixos;
  cfg = config.gab.wm.hyprland;
in
{
  flake.modules.nixos = {
    wm.imports = [ nixos.hyprland ];

    hyprland = {
      imports = [ nixos.wayland ];

      options.gab.wm = {
        hyprland.enable = lib.mkEnableOption "hyprland";
      };

      config = lib.mkIf cfg.enable {
        programs.hyprland = {
          enable = true;
          xwayland.enable = true;
        };

        # to enable swaylock with any compositor other than sway this is needed
        security.pam.services.swaylock = lib.mkDefault { };

        nix.settings = rec {
          substituters = [ "https://hyprland.cachix.org" ];
          trusted-substituters = substituters;
          trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
        };
      };
    };
  };
}
