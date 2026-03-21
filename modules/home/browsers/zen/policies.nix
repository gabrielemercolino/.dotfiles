{ lib, ... }:
{
  flake.modules.homeManager = {
    zen =
      {
        config,
        pkgs,
        user,
        ...
      }:
      let
        cfg = config.gab.browsers.zen;
      in
      {
        programs.zen-browser = lib.mkIf cfg.enable {
          policies = {
            AppAutoUpdate = false;
            AutofillAddressEnabled = false;
            AutofillCreditCardEnabled = false;

            DisableAppUpdate = true;
            DisableFirefoxAccounts = false;
            DisablePasswordReveal = true;
            DisablePocket = true;
            DisableProfileImport = true;
            DisableSafeMode = false;
            DisableTelemetry = true;

            DontCheckDefaultBrowser = true;

            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
              EmailTracking = true;
              SuspectedFingerprinting = true;
              Category = "strict";
              BaselineExceptions = true;
            };

            ExtensionSettings = {
              "*" = {
                installation_mode = "force_installed";
                temporarily_allow_weak_signatures = false;
                private_browsing = true;
              };
            };

            GenerativeAI = {
              Enabled = false;
              Chatbot = false;
              TabGroups = false;
              Locked = true;
            };

            HardwareAcceleration = true;
            ManualAppUpdateOnly = true;
            NoDefaultBookmarks = lib.mkDefault true;
            OfferToSaveLogins = false;
            PasswordManagerEnabled = false;
            PictureInPicture = true;
            PopupBlocking = {
              Default = false;
              Locked = true;
            };

            SearchSuggestEnabled = true;
            SkipTermsOfUse = true;
          };
        };
      };
  };
}
