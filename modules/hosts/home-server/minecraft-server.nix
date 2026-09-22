{ inputs, ... }:
{
  hosts.home-server = {
    nixos =
      {
        config,
        pkgs,
        user,
        ...
      }:
      {
        imports = [
          inputs.playit-nixos-module.nixosModules.default
          inputs.nix-minecraft.nixosModules.minecraft-servers
        ];
        nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

        users.users.${user.name}.extraGroups = [ "minecraft" ];

        sops.secrets = {
          "minecraft/playit/secret".path = "/var/lib/minecraft/playit.secret";
        };

        services = {
          minecraft-servers = {
            enable = true;
            eula = true;
            openFirewall = true;

            servers.minchiaraft = {
              # to enter: `tmux -S /run/minecraft/minchiaraft.sock attach`
              enable = true;
              package = pkgs.fabricServers.fabric-26_3.override {
                jre_headless = pkgs.jdk25_headless;
              };
              jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+UseCompactObjectHeaders";

              serverProperties = {
                server-port = 25565;
                gamemode = "creative";
                simulation-distance = 10;
                level-seed = "4";
                white-list = true;
                motd = "bismillah wallahi";
              };

              whitelist = {
                Sefiul = "c525f516-0bb1-4722-8a86-fc0f7b529dae";
                Nyramu = "af3185c2-9e95-4af8-9dff-449cd683edfb";
                supergman00 = "bcb2a8e2-33e0-4cfc-b2c1-2491120badf8";
              };

              symlinks = {
                mods = pkgs.linkFarmFromDrvs "mods" (
                  builtins.attrValues {
                    Lithium = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/WXHRsMRl/lithium-fabric-0.26.1%2Bmc26.3.jar?mr_download_reason=standalone&mr_game_version=26.3&mr_loader=fabric";
                      sha256 = "sha256-NOXhl8QNo3L2dQDtSWuyGT2RR8EtUPmI4EpRMgXRgBU=";
                    };
                    FerriteCore = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar?mr_download_reason=standalone&mr_game_version=26.3&mr_loader=fabric";
                      sha256 = "sha256-ITlmxy7ZZ6zHOSvrKKhm+6MB/1a5l2wueAHC233mvyI=";
                    };
                    ModernFix = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/TjSm1wrD/versions/iKbywnU7/modernfix-5.27.20-build.1.jar?mr_download_reason=standalone&mr_game_version=26.3&mr_loader=fabric";
                      sha256 = "sha256-wY7N/M9UcBlcPqDrM1BgeEJMBg7XSbXq2nNibEDOEE0=";
                    };
                    FabricAPI = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/bNnaTiuM/fabric-api-0.161.0%2B26.3.jar?mr_download_reason=standalone&mr_game_version=26.3&mr_loader=fabric";
                      sha256 = "sha256-hvFheKPOzIh6haTP6aedkvpzQdjzm1lRpNatgAq2V6Y=";
                    };
                    C2ME = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/VSNURh3q/versions/cfKRtp0m/c2me-fabric-mc26.3-0.4.2-alpha.0.87.jar?mr_download_reason=standalone&mr_game_version=26.3&mr_loader=fabric";
                      sha256 = "sha256-gKTfTqHYlP5U4FhMJarlxFElsH8XIobU7DX32JKoyD4=";
                    };
                    ScalableLux = pkgs.fetchurl {
                      url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/g4eqNSKd/ScalableLux-fabric-mc26.3-0.3.0-alpha.0.6-all.jar?mr_download_reason=standalone&mr_game_version=26.3&mr_loader=fabric";
                      sha256 = "sha256-6RN6BP3vyk/R9HQKs9xhlLXqfBVFbGaRN2uRAFOFOik=";
                    };
                  }
                );
              };
            };
          };

          playit = {
            enable = true;
            secretPath = config.sops.secrets."minecraft/playit/secret".path;
          };
        };
      };
  };
}
