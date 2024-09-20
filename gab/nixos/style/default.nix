{ lib, config, inputs, pkgs, ... }:

let
  cfg = config.gab.style;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];  
  
  options.gab.style = {
    background = lib.mkOption {
      default = pkgs.fetchurl {
        url = "https://github.com/Gingeh/wallpapers/blob/main/os/nix-black-4k.png?raw=true";
        sha256 = "sha256-e1RBd5gTBonG39gYmxCvJuf+qZOiuxeZ9LTjhPQB9vk=";
      };
      type = lib.types.path;
      description = lib.mcDoc "The image to use for background";
    };

    theme = lib.mkOption {
      default = "catppuccin-mocha";
      type = lib.types.enum [ "catppuccin-mocha" "uwunicorn" ];
      description = lib.mcDoc "The theme to use";
    };
  };

  config = {
    stylix.enable = true;
    stylix.autoEnable = true;

    stylix.base16Scheme = ../../../themes + "/${cfg.theme}.yaml";
    stylix.image = cfg.background;

    services.displayManager.sddm.theme = lib.mkForce "${ import ./sddm-theme.nix { inherit pkgs; background  = cfg.background;} }";  
  };

}
