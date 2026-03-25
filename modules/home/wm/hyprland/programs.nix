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
      home = theme.home or { };
    in
    {
      imports = [ inputs.ags-bar.homeManagerModules.default ];

      config = lib.mkIf cfg.enable {
        programs = {
          ghostty =
            let
              ghostty = home.ghostty or { };
            in
            {
              enable = true;
              settings = ghostty.settings or { };
            };

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

          rofi =
            let
              rofi = home.rofi or { };
            in
            {
              enable = true;
              package = pkgs.rofi;
              theme = lib.mkMerge [
                (import ./_rofi-theme.nix { inherit config; })
                (rofi.theme or { })
              ];
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
