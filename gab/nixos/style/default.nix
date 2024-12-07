{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.gab.style;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options.gab.style = {
    background = lib.mkOption {
      default = ./wallpaper.png;
      type = lib.types.path;
      description = "The image to use for background";
    };

    theme = lib.mkOption {
      default = "catppuccin-mocha";
      type = lib.types.enum [
        "catppuccin-mocha"
        "uwunicorn"
      ];
      description = "The theme to use";
    };
  };

  config = {
    stylix.enable = true;
    stylix.autoEnable = true;

    stylix.base16Scheme = ../../../themes/${cfg.theme}.yaml;
    stylix.image = cfg.background;

    services.displayManager.sddm.theme = lib.mkForce "${import ./sddm-theme.nix {
      inherit pkgs;
      background = cfg.background;
    }}";
  };

}
