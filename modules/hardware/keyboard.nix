{
  self,
  lib,
  ...
}: {
  flake.nixosModules.keyboard = {config, ...}: let
    cfg = config.gab.hardware.keyboard;
  in {
    options.gab.hardware.keyboard = with lib.types; {
      layout = lib.mkOption {
        type = str;
        example = "it";
      };

      variant = lib.mkOption {
        type = str;
        default = "";
        example = "nodeadkeys";
      };
    };

    config = {
      console.keyMap = cfg.layout;
      services.xserver.xkb = {
        layout = cfg.layout;
        variant = cfg.variant;
      };
    };
  };

  flake.homeModules.keyboard = {...}: {
    options.gab.hardware.keyboard = with lib.types; {
      layout = lib.mkOption {
        type = str;
        example = "it";
      };

      variant = lib.mkOption {
        type = str;
        default = "";
        example = "nodeadkeys";
      };
    };
  };

  flake.nixosModules.hardware = _: {imports = [self.nixosModules.keyboard];};
  flake.homeModules.hardware = _: {imports = [self.homeModules.keyboard];};
}
