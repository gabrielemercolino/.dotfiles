{lib, ...}:
with lib.types; {
  flake.homeModules.keyboard = {...}: {
    options.gab.keyboard = {
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
