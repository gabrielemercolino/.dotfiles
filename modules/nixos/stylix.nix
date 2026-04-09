{ inputs, lib, ... }:
{
  flake.modules.nixos.stylix =
    {
      config,
      pkgs,
      loadTheme,
      ...
    }:
    let
      cfg = config.gab.stylix;

      theme = loadTheme { inherit config lib pkgs; };

      polarity = theme.polarity;
      background = theme.background;
      palette = theme.palette;
      fonts = theme.fonts or { };
      nixos = theme.nixos or { };
    in
    {
      imports = [ inputs.stylix.nixosModules.default ];

      options.gab.stylix = {
        fonts.sizes = {
          applications = lib.mkOption {
            description = "The font size used for applications";
            default = 12;
          };
          desktop = lib.mkOption {
            description = "The font size used for window titles, status bars, and other general elements of the desktop";
            default = 10;
          };
          popups = lib.mkOption {
            description = "The font size used for notifications, popups, and other overlay elements of the desktop";
            default = 10;
          };
          terminal = lib.mkOption {
            description = "The font size used for terminals and text editors";
            default = 12;
          };
        };
      };

      config = lib.mkMerge [
        (nixos)
        {
          stylix = {
            enable = true;
            autoEnable = true;

            base16Scheme = palette;
            image = background;
            polarity = polarity;

            fonts = fonts // cfg.fonts;

            targets = {
              gtksourceview.enable = false;
            };
          };
        }
      ];
    };
}
