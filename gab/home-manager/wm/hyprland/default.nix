{
  config,
  lib,
  inputs,
  pkgs,
  systemSettings,
  ...
}: let
  bar = import ./ags-bar.nix {
    inherit pkgs config;
    inherit (inputs) ags-bar;
  };

  kill-bar = "pkill gjs";
in {
  imports = [
    inputs.hyprland-nix.homeManagerModules.default
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

    home.activation.ags-bar = lib.hm.dag.entryAfter ["writeBoundary"] ''
      old_path="${config.home.homeDirectory}/.local/state/ags-bar-path"
      new_path="${bar}"

      if [ -f "$old_path" ] && [ "$(cat "$old_path")" = "$new_path" ]; then
        echo "not restarting ags-bar"
      else
        echo "$new_path" > "$old_path"
        echo "restarting ags-bar"
        ${pkgs.procps}/bin/pkill gjs 2> /dev/null || true
        ${lib.getExe bar} > /dev/null 2> /dev/null &
      fi
    '';

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
        (import ./config.nix {inherit bar lib pkgs config systemSettings;})
      ];

      keyBinds = import ./keybinds.nix {inherit lib pkgs bar kill-bar;};

      animations.animation = import ./animations.nix {};
    };
  };
}
