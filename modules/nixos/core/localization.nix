{ self, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.localization ];

    localization =
      { localization, ... }:
      {
        console.keyMap = localization.keyboard.layout;
        services.xserver.xkb = {
          layout = localization.keyboard.layout;
          variant = localization.keyboard.variant;
        };

        i18n.defaultLocale = localization.locale;

        time = {
          timeZone = localization.time.zone;
          hardwareClockInLocalTime = localization.time.hardware-clock.enable;
        };
      };
  };
}
