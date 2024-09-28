{ pkgs, userSettings, ... }:

{
  imports = [
    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # for amd gpus
  boot.initrd.kernelModules   = [ "amdgpu" ];
  nixpkgs.config.rocmSupport  = true;

  # use zsh
  users.defaultUserShell  = pkgs.zsh;
  programs.zsh.enable     = true;

  gab.login.sddm = true;
  
  gab.hardware.bluetooth  = true;
  gab.hardware.pipewire   = true;
  #gab.hardware.amdvlk    = true;
  gab.hardware.i18n.locale      = "it_IT.UTF-8";
  gab.hardware.keyboard.layout  = "it";
  gab.hardware.time.timeZone    = "Europe/Rome";

  gab.apps.security.ssh     = true;
  gab.apps.services.dbus    = true;
  gab.apps.control.corectrl = true;
  gab.apps.control.lact     = true;
  gab.apps.dev.direnv       = true;
  gab.apps.dev.docker       = true;

  gab.wm.hyprland      = true;

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

  services.xserver.excludePackages = [ pkgs.xterm ];
}
