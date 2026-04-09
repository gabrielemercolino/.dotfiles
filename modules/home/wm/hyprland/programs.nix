{ inputs, lib, ... }:
{
  flake.modules.homeManager.hyprland =
    {
      config,
      pkgs,
      loadTheme,
      ...
    }:
    let
      cfg = config.gab.wm.hyprland;
      theme = loadTheme { inherit config lib pkgs; };
    in
    {
      imports = [ inputs.ags-bar.homeManagerModules.default ];

      config = lib.mkIf cfg.enable {
        programs = {
          ghostty.enable = true;

          swaylock = {
            enable = true;
            settings = {
              package = pkgs.swaylock-effects;
              effect-blur = "7x5";
              effect-vignette = "0.7:0.7";
              indicator = true;
              clock = true;
            };
          };

          ags-bar = {
            enable = true;
            systemd.enable = true;

            fonts = [ "DejaVu Sans Mono" ];
            colors.base16 = theme.palette;

            commands.lock = "${pkgs.swaylock-effects}/bin/swaylock";
          };

          rofi = {
            enable = true;
            package = pkgs.rofi;
            theme = (import ./_rofi-theme.nix { inherit config; });
            extraConfig = {
              modi = "drun";
              show-icons = true;
              icon-theme = "WhiteSur";
              display-drun = "run";
              drun-display-format = "{name}";
            };
          };
        };
      };
    };
}
