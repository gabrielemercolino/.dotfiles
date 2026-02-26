{lib, ...}:
with lib.types; {
  flake.homeModules.hardware = {...}: {
    options.gab.hardware.keyboard = {
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
}
