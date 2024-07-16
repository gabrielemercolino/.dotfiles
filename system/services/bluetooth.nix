{ ... }:

{
  hardware.bluetooth.enable = true;      # enables support for bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  services.blueman.enable = true; # cli to control bluetooth
}
