{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.gab.hardware;
in
{
  options.gab.hardware = {
    amdvlk = lib.mkEnableOption "amdvlk drivers";
    bluetooth = lib.mkEnableOption "bluetooth";
    pipewire = lib.mkEnableOption "pipewire";
    pulseaudio = lib.mkEnableOption "pulseaudio";
    keyboard = lib.mkOption {
      type = with lib.types; submodule {
        options = {
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
      };

      default = {
        layout = null;
        variant = "";
      };
    };
    i18n = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          locale = lib.mkOption {
            default = "en_US.UTF-8";
            type = str;
            description = "The default locale for the system";
            example = "it_IT.UTF-8";
          };
        };
      };

      default = {
        locale = "en_US.UTF-8";
      };
    };
    time = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          automatic = lib.mkOption {
            default = false;
            type = bool;
            description = "Whether to automatically set the time zone based on current location.";
            example = true;
          };
          timeZone = lib.mkOption {
            default = null;
            type = nullOr str;
            description = "The time zone (e.g., 'Europe/Rome').";
            example = "Europe/Rome";
          };
        };
      };

      default = {
        automatic = false;
        timeZone = null;
      };

      description = "Options for setting time and time zone, including automatic time zone detection.";
    };
    networking = lib.mkOption {  
      type = with lib.types; submodule {
        options = {
          hostName = lib.mkOption {
            default = "nixos";
            type = str;
            description = "The host name";
          };
        };
      };

      default = { 
        hostName = "nixos";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.pipewire && cfg.pulseaudio);
        message = "Error: cannot activate both pipewire and pulseaudio";
      }
      {
        assertion = cfg.keyboard.layout != null;
        message = "Error: keyboard layout is not set";
      }
      {
        assertion = (cfg.time.automatic && cfg.time.timeZone == null)
                    || (!cfg.time.automatic && builtins.isString cfg.time.timeZone);
        message = "Error: must set either automatic or timeZone (not both)";
      }
    ];

    users.users.${userSettings.userName}.extraGroups = [ "audio" "jackaudio" "networkmanager" ];

    ## graphics related settings
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.libvdpau-va-gl ] # for hardware acceleration
                      ++ lib.optionals cfg.amdvlk [ pkgs.amdvlk ];
      extraPackages32 = lib.optionals cfg.amdvlk [ pkgs.driversi686Linux.amdvlk ];
    };

    ## bluetooth
    hardware.bluetooth.enable = cfg.bluetooth;
    services.blueman.enable = lib.mkDefault true; # provide bluetooth control with blueman by default

    ### pipewire
    security.rtkit.enable = true;  # rtkit is optional but recommended
    services.pipewire = {
      enable              = true;
      alsa.enable         = true;
      alsa.support32Bit   = true;
      pulse.enable        = true;
      jack.enable         = true;
      wireplumber.enable  = true;
    };

    ### pulseaudio
    hardware.pulseaudio.enable = cfg.pulseaudio;
    hardware.pulseaudio.support32Bit = cfg.pulseaudio;

    ## keyboard related settings
    console.keyMap = cfg.keyboard.layout;
    services.xserver.xkb = {
      layout = cfg.keyboard.layout;
      variant = cfg.keyboard.variant;
    };

    ## i18n related settings
    i18n.defaultLocale = cfg.i18n.locale;

    i18n.extraLocaleSettings = {
      LC_ADDRESS        = lib.mkDefault cfg.i18n.locale;
      LC_IDENTIFICATION = lib.mkDefault cfg.i18n.locale;
      LC_MEASUREMENT    = lib.mkDefault cfg.i18n.locale;
      LC_MONETARY       = lib.mkDefault cfg.i18n.locale;
      LC_NAME           = lib.mkDefault cfg.i18n.locale;
      LC_NUMERIC        = lib.mkDefault cfg.i18n.locale;
      LC_PAPER          = lib.mkDefault cfg.i18n.locale;
      LC_TELEPHONE      = lib.mkDefault cfg.i18n.locale;
      LC_TIME           = lib.mkDefault cfg.i18n.locale;
    };

    ## timezone related settings
    time.timeZone = lib.mkIf (!cfg.time.automatic) cfg.time.timeZone;
    time.hardwareClockInLocalTime = lib.mkDefault true; # needed for dual boot with windows but if not dual booting it doesn't hurt

    ## networking related settings
    networking.hostName = cfg.networking.hostName;
    networking.networkmanager.enable = lib.mkDefault true; # provide by default network access with networkmanager
  };
}
