{
  self,
  lib,
  ...
}: {
  flake.nixosModules.localization = {config, ...}: let
    cfg = config.gab.hardware.localization;
  in {
    options.gab.hardware.localization = with lib.types; {
      i18n = {
        locale = lib.mkOption {
          type = str;
          description = "The default locale for the system";
          example = "it_IT.UTF-8";
        };
      };

      time = {
        timeZone = lib.mkOption {
          type = str;
          description = "The time zone";
          example = "Europe/Rome";
        };
        hardware-clock.enable = lib.mkEnableOption "hardware clock (for dual boot)";
      };
    };

    config = {
      i18n = rec {
        defaultLocale = cfg.i18n.locale;

        extraLocaleSettings =
          [
            "LC_ADDRESS"
            "LC_IDENTIFICATION"
            "LC_MEASUREMENT"
            "LC_MONETARY"
            "LC_NAME"
            "LC_NUMERIC"
            "LC_PAPER"
            "LC_TELEPHONE"
            "LC_TIME"
          ]
          |> map (el: {
            name = el;
            value = lib.mkDefault defaultLocale;
          })
          |> builtins.listToAttrs;
      };

      time = {
        timeZone = cfg.time.timeZone;
        hardwareClockInLocalTime = cfg.time.hardware-clock.enable; # needed for dual boot with windows
      };
    };
  };

  flake.nixosModules.hardware = _: {imports = [self.nixosModules.localization];};
}
