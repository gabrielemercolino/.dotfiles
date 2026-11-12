{ self, lib, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.audio ];

    audio =
      {
        config,
        pkgs,
        audio,
        user,
        ...
      }:
      {
        users.users.${user.name}.extraGroups = lib.mkIf (audio != null) [ "audio" ];

        security.rtkit.enable = lib.mkDefault (audio == "pipewire"); # rtkit is optional but recommended

        services = {
          pipewire = {
            enable = audio == "pipewire";
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            wireplumber.enable = true;
          };

          pulseaudio = {
            enable = audio == "pulseaudio";
            support32Bit = true;
            package = pkgs.pulseaudioFull;
            extraConfig = "load-module module-combine-sink";
          };
        };
      };
  };
}
