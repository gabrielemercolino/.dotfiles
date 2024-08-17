{ systemSettings, ... }:

{
  imports = [
    ./pipewire.nix
    ./sddm.nix
  ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = systemSettings.keyLayout;
      variant = "";
    };
  };
}
