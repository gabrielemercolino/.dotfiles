{ ... }:
{
  hosts.home-server = {
    nixos =
      { config, pkgs, ... }:
      {
        sops = {
          secrets."homepage/jellyfin/key" = { };
          templates."homepage.env".content = ''
            HOMEPAGE_VAR_JELLYFIN=${config.sops.placeholder."homepage/jellyfin/key"}
          '';
        };

        services = {
          homepage-dashboard = {
            enable = true;
            listenPort = 8082;
            allowedHosts = "home.ciruzzo.win";
            settings.title = "Home Server";
            environmentFiles = [ config.sops.templates."homepage.env".path ];

            widgets = [
              {
                resources = {
                  label = "Sistema";
                  cpu = true;
                  memory = true;
                  cputemp = true;
                  uptime = true;
                };
              }
              {
                resources = {
                  label = "NixOS";
                  disk = "/";
                };
              }
              {
                resources = {
                  label = "Tank";
                  disk = "/tank";
                };
              }
            ];

            services = [
              {
                "Sicurezza" = [
                  {
                    "Vaultwarden" = {
                      href = "https://vaultwarden.ciruzzo.win";
                      icon = "vaultwarden.png";
                      description = "Password manager";
                    };
                  }
                  {
                    "Duplicati" = {
                      href = "https://duplicati.ciruzzo.win";
                      icon = "duplicati.png";
                      description = "Backup automatici";
                    };
                  }
                ];
              }
              {
                "Media" = [
                  {
                    "Jellyfin" = rec {
                      href = "https://jellyfin.ciruzzo.win";
                      icon = "jellyfin.png";
                      description = "Streaming";
                      widget = {
                        type = "jellyfin";
                        url = href;
                        key = "525c1d5078a64ae497c78eaf81891cd2";
                        version = 2;
                        enableBlocks = true;
                        enableNowPlaying = true;
                      };
                    };
                  }
                ];
              }
              {
                "Dev" = [
                  {
                    "Forgejo" = {
                      href = "https://forgejo.ciruzzo.win";
                      icon = "forgejo.png";
                      description = "Hosting di codice sorgente e collaborazione";
                    };
                  }
                ];
              }
              {
                "Utilità" = [
                  {
                    "Transmute" = {
                      href = "https://transmute.ciruzzo.win";
                      description = "Conversione e compressione file";
                    };
                  }
                ];
              }
            ];
          };
        };
      };
  };
}
