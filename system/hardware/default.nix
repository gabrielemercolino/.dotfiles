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
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.pipewire && cfg.pulseaudio);
        message = "Error: cannot activate both pipewire and pulseaudio";
      }
    ];

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
    
    ## audio related settings
    users.users.${userSettings.userName}.extraGroups = [ "audio" "jackaudio" ];

    ### pipewire
    security.rtkit.enable = true;  # rtkit is optional but recommended
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };


    ### pulseaudio
    hardware.pulseaudio.enable = cfg.pulseaudio;
    hardware.pulseaudio.support32Bit = cfg.pulseaudio;
  };
}
