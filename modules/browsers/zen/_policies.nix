{lib}: {
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

  SearchEngines = {
    Add = [
      {
        Name = "Brave Search";
        URLTemplate = "https://search.brave.com/search?q={searchTerms}";
        Method = "GET";
        IconURL = "https://brave.com/static-assets/images/brave-favicon.png";
        Alias = "brave";
        Description = "Brave Search";
      }
      {
        Name = "MyNixOS";
        URLTemplate = "https://mynixos.com/search?q={searchTerms}";
        Method = "GET";
        IconURL = "https://mynixos.com/favicon.ico";
        Alias = "mynix";
        Description = "Search NixOS options and packages";
      }
    ];
    Remove = ["Bing" "Ecosia" "Google" "Perplexity" "Qwant" "Wikipedia (en)"];
    Default = "Brave Search";
    PreventInstalls = true;
  };
  SearchSuggestEnabled = true;
  SkipTermsOfUse = true;
}
