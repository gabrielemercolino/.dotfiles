{ pkgs, userSettings, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # for amd gpus
  boot.initrd.kernelModules  = [ "amdgpu" ];
  nixpkgs.config.rocmSupport = true;

  # use zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable    = true;

  gab.login.sddm = true;
  
  gab.hardware = {
    bluetooth = true;
    pipewire  = true;
    amdvlk    = false;

    i18n.locale     = "it_IT.UTF-8";
    keyboard.layout = "it";
    time.timeZone   = "Europe/Rome";
  };

  gab.apps = {
    ssh  = true;
    dbus = true;

    corectrl = true;
    lact     = true;

    direnv = true;
    docker = true;
  };

  gab.gaming = {
    steam     = true;
    gamemode  = true;
    gamescope = true;
  };

  gab.wm.hyprland = true;

  # Some games are installed in the G: partition
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/home/gabriele/Games/Steam" = { 
    device = "/dev/disk/by-label/G";
    fsType = "ntfs-3g";
    options = [ "rw" "uid=${userSettings.userName}" "nofail"];
  };

  services.xserver.excludePackages = [ pkgs.xterm ];
}
