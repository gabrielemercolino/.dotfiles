{ inputs, ... }:
{
  hosts.home-server = {
    nixos = { config, ... }: {
      imports = [ inputs.playit-nixos-module.nixosModules.default ];

      sops.secrets = {
        "minecraft/playit/secret".path = "/var/lib/minecraft/playit.secret";
      };

      services = {
        minecraft-server = {
          enable = true;
          eula = true;
          declarative = true;

          serverProperties = {
            gamemode = "creative";
            simulation-distance = 10;
            level-seed = "4";
            white-list = true;
          };

          whitelist = {
            Sefiul = "c525f516-0bb1-4722-8a86-fc0f7b529dae";
            Nyramu = "af3185c2-9e95-4af8-9dff-449cd683edfb";
            supergman00 = "bcb2a8e2-33e0-4cfc-b2c1-2491120badf8";
          };

          jvmOpts = "-Xms4092M -Xmx4092M -XX:+UseG1GC -XX:+UseCompactObjectHeaders";
        };

        playit = {
          enable = true;
          secretPath = config.sops.secrets."minecraft/playit/secret".path;
        };
      };
    };
  };
}
