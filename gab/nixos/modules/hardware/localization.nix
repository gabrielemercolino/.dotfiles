{
  config,
  lib,
  ...
}:
with lib.types; let
  cfg = config.gab.hardware;
in {
  options.gab.hardware = {
    keyboard = {
      layout = lib.mkOption {
        type = str;
        description = "Keyboard layout";
        example = "de";
      };
      variant = lib.mkOption {
        default = "";
        type = str;
        description = "Keyboard variant";
        example = "nodeadkeys";
      };
    };

    i18n = {
      locale = lib.mkOption {
        default = "en_US.UTF-8";
        type = str;
        description = "The default locale for the system";
        example = "it_IT.UTF-8";
      };
    };

    time = {
      automatic = lib.mkEnableOption "automatic time zone detection";
      timeZone = lib.mkOption {
        default = null;
        type = nullOr str;
        description = "The time zone";
        example = "Europe/Rome";
      };
      hardware-clock.enable = lib.mkEnableOption "hardware clock (for dual boot)";
    };
  };

  config = {
    assertions = [
      {
        assertion =
          (cfg.time.automatic && cfg.time.timeZone == null)
          || (!cfg.time.automatic && builtins.isString cfg.time.timeZone);
        message = "Error: must set either automatic or timeZone (not both)";
      }
    ];

    ## keyboard related settings
    console.keyMap = cfg.keyboard.layout;
    services.xserver.xkb = {
      layout = cfg.keyboard.layout;
      variant = cfg.keyboard.variant;
    };

    ## i18n related settings
    i18n.defaultLocale = cfg.i18n.locale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS = lib.mkDefault cfg.i18n.locale;
      LC_IDENTIFICATION = lib.mkDefault cfg.i18n.locale;
      LC_MEASUREMENT = lib.mkDefault cfg.i18n.locale;
      LC_MONETARY = lib.mkDefault cfg.i18n.locale;
      LC_NAME = lib.mkDefault cfg.i18n.locale;
      LC_NUMERIC = lib.mkDefault cfg.i18n.locale;
      LC_PAPER = lib.mkDefault cfg.i18n.locale;
      LC_TELEPHONE = lib.mkDefault cfg.i18n.locale;
      LC_TIME = lib.mkDefault cfg.i18n.locale;
    };

    ## timezone related settings
    time.timeZone = lib.mkIf (!cfg.time.automatic) cfg.time.timeZone;
    time.hardwareClockInLocalTime = cfg.time.hardware-clock.enable; # needed for dual boot with windows
  };
}
