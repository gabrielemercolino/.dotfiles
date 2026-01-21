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
    audio-server = lib.mkOption {
      default = null;
      type = nullOr (enum ["pipewire" "pulseaudio"]);
      description = "The audio server to use";
    };
  };

  config = {
    users.users.${userSettings.userName}.extraGroups = [
      "audio"
      "jackaudio"
    ];

    ### pipewire
    security.rtkit.enable = lib.mkDefault (cfg.audio-server == "pipewire"); # rtkit is optional but recommended
    services.pipewire = {
      enable = cfg.audio-server == "pipewire";
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    ### pulseaudio
    services.pulseaudio = {
      enable = cfg.audio-server == "pulseaudio";
      support32Bit = true;
      package = pkgs.pulseaudioFull;
      extraConfig = "load-module module-combine-sink";
    };
  };
}