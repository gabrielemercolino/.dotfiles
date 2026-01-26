{
  config,
  lib,
  inputs,
  pkgs,
  systemSettings,
  ...
}: {
  imports = [
    inputs.hyprland-nix.homeManagerModules.default
    inputs.ags-bar.homeManagerModules.default
  ];

  options.gab.wm.hyprland = {
    enable = lib.mkEnableOption "hyprland";
    monitors = lib.mkOption {
      type = with lib.types; listOf str;
      default = [];
    };
  };

  config = lib.mkIf config.gab.wm.hyprland.enable {
    home.packages = with pkgs; [
      wev
      wlr-randr
      wl-clipboard
    ];

    programs.ags-bar = {
      enable = true;
      systemd.enable = true;

      commands.lock = "${pkgs.swaylock-effects}/bin/swaylock";
    };

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;

      reloadConfig = true;
      systemd.enable = true;
      recommendedEnvironment = true;
      xwayland.enable = true;

      environment = {};

      config = lib.mkMerge [
        {monitor = config.gab.wm.hyprland.monitors ++ [", preferred, auto, 1"];}
        (import ./config.nix {inherit lib pkgs config systemSettings;})
      ];

      keyBinds = import ./keybinds.nix {inherit lib pkgs;};

      animations.animation = import ./animations.nix {};
    };
  };
}
