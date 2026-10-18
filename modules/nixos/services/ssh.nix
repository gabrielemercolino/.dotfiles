{ self, lib, ... }:
{
  flake.modules.nixos = {
    services.imports = [ self.modules.nixos.ssh ];
    hm.imports = [ self.modules.nixos.ssh-hm ];

    ssh-hm =
      {
        config,
        pkgs,
        user,
        ...
      }:
      {
        config = lib.mkIf config.gab.services.ssh.enable {
          home-manager.users.${user.name}.programs.ssh = {
            enable = true;
            matchBlocks."git.ciruzzo.win" = {
              user = "forgejo";
              proxyCommand = "${lib.getExe pkgs.cloudflared} access ssh --hostname %h";
            };
          };
        };
      };

    ssh =
      { config, pkgs, ... }:
      let
        cfg = config.gab.services.ssh;
      in
      {
        options.gab.services.ssh = {
          enable = lib.mkEnableOption "ssh";
        };

        config = lib.mkIf cfg.enable {
          services.openssh.enable = true;
        };
      };

  };
}
