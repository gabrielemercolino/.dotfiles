{ pkgs, userSettings, ... }:

{
  imports = [
    ../base/configuration.nix

    ../../system/hardware
    ../../system/apps
    ../../system/gaming
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  gab.hardware.bluetooth  = true;
  gab.hardware.pipewire   = true;
  #gab.hardware.amdvlk    = true;
  gab.hardware.i18n.locale      = "it_IT.UTF-8";
  gab.hardware.keyboard.layout  = "it";
  gab.hardware.time.timeZone    = "Europe/Rome";

  gab.apps.control.corectrl = true;
  gab.apps.control.lact     = true;
  gab.apps.dev.direnv       = true;
  gab.apps.dev.docker       = true;

  # for amd gpus
  boot.initrd.kernelModules   = [ "amdgpu" ];
  nixpkgs.config.rocmSupport  = true;

  gab.gaming.steam      = true;
  gab.gaming.gamemode   = true;
  gab.gaming.gamescope  = true;

  # Some games are installed in the G: partition
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/home/gabriele/Games/Steam" = { 
    device = "/dev/disk/by-label/G";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=${userSettings.userName}" "nofail"];
  };
}
