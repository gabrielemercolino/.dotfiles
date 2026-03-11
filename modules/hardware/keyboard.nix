{
  self,
  lib,
  ...
}: {
  flake.homeModules.keyboard = {...}: {
    options.gab.keyboard = with lib.types; {
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

  flake.homeModules.hardware = _: {imports = [self.homeModules.keyboard];};
}
