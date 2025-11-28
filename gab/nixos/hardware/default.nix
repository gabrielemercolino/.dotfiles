{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:
with lib.types; let
  cfg = config.gab.hardware;
in {
  options.gab.hardware = {
    bluetooth.enable = lib.mkEnableOption "bluetooth";
    pipewire.enable = lib.mkEnableOption "pipewire";
    pulseaudio.enable = lib.mkEnableOption "pulseaudio";

    keyboard = {
      layout = lib.mkOption {
        default = null;
        type = nullOr str;
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
        assertion = !(cfg.pipewire.enable && cfg.pulseaudio.enable);
        message = "Error: cannot activate both pipewire and pulseaudio";
      }
      {
        assertion = cfg.keyboard.layout != null;
        message = "Error: keyboard layout is not set";
      }
      {
        assertion =
          (cfg.time.automatic && cfg.time.timeZone == null)
          || (!cfg.time.automatic && builtins.isString cfg.time.timeZone);
        message = "Error: must set either automatic or timeZone (not both)";
      }
    ];

    users.users.${userSettings.userName}.extraGroups = [
      "audio"
      "jackaudio"
      "networkmanager"
    ];

    ## graphics related settings
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    ## bluetooth
    hardware.bluetooth.enable = cfg.bluetooth.enable;
    hardware.bluetooth.powerOnBoot = false;

    ### pipewire
    security.rtkit.enable = lib.mkDefault cfg.pipewire.enable; # rtkit is optional but recommended
    services.pipewire = {
      enable = cfg.pipewire.enable;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    ### pulseaudio
    services.pulseaudio = {
      enable = cfg.pulseaudio.enable;
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      extraConfig = "load-module module-combine-sink";
    };

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

    ## networking related settings
    networking.hostName = lib.mkDefault "nixos";
    networking.networkmanager.enable = lib.mkDefault true; # provide by default network access with networkmanager
  };
}
