{
  self,
  lib,
  ...
}: {
  flake.nixosModules.audio = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.hardware.audio;
  in {
    imports = [self.nixosModules.user];

    options.gab.hardware.audio = with lib.types; {
      server = lib.mkOption {
        default = null;
        type = nullOr (enum ["pipewire" "pulseaudio"]);
        description = "The audio server to use";
      };
    };

    config = {
      users.users.${config.gab.user.name}.extraGroups = ["audio" "jackaudio"];

      # rtkit is optional but recommended
      security.rtkit.enable = lib.mkDefault (cfg.server == "pipewire");

      services = {
        pipewire = {
          enable = cfg.server == "pipewire";
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = true;
          wireplumber.enable = true;
        };

        pulseaudio = {
          enable = cfg.server == "pulseaudio";
          support32Bit = true;
          package = pkgs.pulseaudioFull;
          extraConfig = "load-module module-combine-sink";
        };
      };
    };
  };

  flake.nixosModules.hardware = _: {imports = [self.nixosModules.audio];};
}
