{ self, lib, ... }@params:
{
  flake.modules.homeManager.style =
    {
      config,
      pkgs,
      host,
      ...
    }:
    let
      cfg = config.gab.style;
    in
    {
      imports = lib.optionals (host.theme != null) [
        ((import "${self.outPath}/themes/${host.theme}" params).home)
      ];

      options.gab.style = {
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

      # mkIf doesn't work in this case
      config =
        if (host.theme != null) then
          {
            stylix = {
              enable = true;
              autoEnable = true;

              fonts = cfg.fonts;

              targets = {
                gtksourceview.enable = false;
                mangohud.enable = false;
                vscode.enable = false;
                rofi.enable = false;
                zen-browser.enable = false;
                qt.enable = true;
              };
            };
          }
        else
          { };
    };
}
