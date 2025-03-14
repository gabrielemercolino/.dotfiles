{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../base/configuration.nix
    ../../gab/nixos
  ];

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  # use zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  gab.login.sddm.enable = true;

  gab.hardware = {
    bluetooth.enable = true;
    #pipewire.enable = true;
    pulseaudio.enable = true;

    i18n.locale = "it_IT.UTF-8";
    keyboard.layout = "it";
    time.timeZone = "Europe/Rome";
  };

  gab.apps = {
    ssh.enable = true;
    dbus.enable = true;

    corectrl.enable = true;
    bashmount.enable = true;

    direnv.enable = true;
    docker.enable = true;
  };

  # to run visual paradigm
  gab.gaming.steam.enable = true;

  gab.wm.bspwm.enable = true;

  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.displayManager.sessionCommands = "xrdb -merge <<< \"Xft.dpi: 120\"";
}
