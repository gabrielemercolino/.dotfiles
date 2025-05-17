{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  # for amd gpus
  hardware.amdgpu.initrd.enable = true;
  hardware.graphics.extraPackages = [pkgs.libva];
  nixpkgs.config.rocmSupport = true;

  # use zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  gab.login.sddm.enable = true;

  gab.hardware = {
    bluetooth.enable = true;
    pipewire.enable = true;
    #pulseaudio.enable = true;
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
    bashmount.enable = true;

    direnv.enable = true;
    docker.enable = true;
  };

  gab.gaming = {
    steam.enable = true;
    gamemode.enable = true;
    gamescope.enable = true;
    #rpcs3.enable = true;
  };

  gab.wm.hyprland.enable = true;
  gab.wm.bspwm.enable = true;

  services.xserver.excludePackages = [pkgs.xterm];
}
