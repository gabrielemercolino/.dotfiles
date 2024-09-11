{ lib, config, stylix, pkgs, ... }:

let
  cfg = config.gab.style;
in
{
  imports = [ stylix.homeManagerModules.stylix ];  
  
  options.gab.style = {
    background = lib.mkOption {
      default = pkgs.fetchurl {
        url = "https://github.com/Gingeh/wallpapers/blob/main/os/nix-black-4k.png?raw=true";
        sha256 = "sha256-e1RBd5gTBonG39gYmxCvJuf+qZOiuxeZ9LTjhPQB9vk=";
      };
      type = lib.types.path;
      description = "The image to use for background";
    };

    theme = lib.mkOption {
      default = "catppuccin-mocha";
      type = lib.types.str;
      description = "The theme to use";
    };
  };

  config = {
    stylix.enable = true;
    stylix.autoEnable = true;

    stylix.base16Scheme = ../../themes + "/${cfg.theme}.yaml";
    stylix.image = cfg.background;

    stylix.targets.mangohud.enable = false;

    # config.lib needed as 'normal' lib is from nix but config.lib is from home-manager
    # and mkLiteral is present only in home-manager
    programs.rofi.theme = lib.mkForce (import ./rofi-theme.nix { inherit config; } );
  };

}
