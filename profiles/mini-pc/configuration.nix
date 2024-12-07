{ pkgs, userSettings, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # for amd gpus
  hardware.amdgpu.initrd.enable = true;
  hardware.graphics.extraPackages = [ pkgs.libva ];
  nixpkgs.config.rocmSupport = true;

  # use zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  gab.login.sddm.enable = true;

  gab.hardware = {
    bluetooth.enable = true;
    #pipewire.enable = true;
    pulseaudio.enable = true;
    amdvlk.enable = false;

    i18n.locale = "it_IT.UTF-8";
    keyboard.layout = "it";
    time.timeZone = "Europe/Rome";
  };

  gab.apps = {
    ssh.enable = true;
    dbus.enable = true;

    corectrl.enable = true;
    lact.enable = true;

    direnv.enable = true;
    docker.enable = true;
  };

  gab.gaming = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    suyu.enable = true;
  };

  gab.wm.hyprland.enable = true;

  # Some games are installed in the G: partition
  boot.supportedFilesystems = [ "ntfs" ];
  fileSystems."/home/gabriele/Games/Steam" = {
    device = "/dev/disk/by-label/G";
    fsType = "ntfs-3g";
    options = [
      "rw"
      "uid=${userSettings.userName}"
      "nofail"
    ];
  };

  services.xserver.excludePackages = [ pkgs.xterm ];
}
