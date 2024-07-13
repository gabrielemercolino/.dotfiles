{ config, pkgs, userSettings, systemSettings, ... }:

{
	boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
