{
  self,
  inputs,
  lib,
  ...
}: {
  flake.nixosModules.hyprland = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.wm.hyprland;
  in {
    imports = [self.nixosModules.screen-record];
    options.gab.wm.hyprland = {
      enable = lib.mkEnableOption "hyprland";
    };

    config = lib.mkIf cfg.enable {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        portalPackage = pkgs.xdg-desktop-portal-hyprland;
      };

      # to enable swaylock with any compositor other than sway this is needed
      security.pam.services.swaylock = lib.mkDefault {};

      nix.settings = rec {
        substituters = ["https://hyprland.cachix.org"];
        trusted-substituters = substituters;
        trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
      };
    };
  };

  flake.homeModules.hyprland = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.wm.hyprland;
  in {
    imports = [
      inputs.hyprland-nix.homeManagerModules.default
      inputs.ags-bar.homeManagerModules.default
      self.homeModules.keyboard
    ];

    options.gab.wm.hyprland = {
      enable = lib.mkEnableOption "hyprland";
      monitors = lib.mkOption {
        type = with lib.types; listOf str;
        default = [];
      };
    };

    config = lib.mkIf cfg.enable {
      home.packages = with pkgs; [wev wlr-randr wl-clipboard];

      programs.ags-bar = {
        enable = true;
        systemd.enable = true;

        commands.lock = "${pkgs.swaylock-effects}/bin/swaylock";
      };

      programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
      };

      wayland.windowManager.hyprland = let
        system = pkgs.stdenv.hostPlatform.system;
      in {
        enable = true;

        reloadConfig = true;
        systemd.enable = true;
        recommendedEnvironment = true;
        xwayland.enable = true;

        environment = {};

        config = lib.mkMerge [
          {monitor = cfg.monitors ++ [", preferred, auto, 1"];}
          (import ./_config.nix {
            inherit lib pkgs config;
            keyboard = config.gab.keyboard;
          })
        ];

        keyBinds = import ./_keybinds.nix {
          inherit lib pkgs;
          screen-record = self.packages.${system}.screen-record;
          screen-shot = self.packages.${system}.screen-shot;
        };

        animations = import ./_animations.nix {};
      };
    };
  };

  flake.nixosModules.wm = _: {imports = [self.nixosModules.hyprland];};
  flake.homeModules.wm = _: {imports = [self.homeModules.hyprland];};
}
