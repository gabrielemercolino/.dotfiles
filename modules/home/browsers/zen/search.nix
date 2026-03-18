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
          policies.SearchEngines = {
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
            Remove = [
              "Bing"
              "Ecosia"
              "Google"
              "Perplexity"
              "Qwant"
              "Wikipedia (en)"
            ];
            Default = "Brave Search";
            PreventInstalls = true;
          };
        };
      };
  };
}
