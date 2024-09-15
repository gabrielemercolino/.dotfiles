{ systemSettings, ... }:

{
  imports = [
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
