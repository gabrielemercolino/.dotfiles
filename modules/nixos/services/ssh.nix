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
            enableDefaultConfig = false;
            settings."*" = {
              ForwardAgent = false;
              AddKeysToAgent = "no";
              Compression = false;
              ServerAliveInterval = 0;
              ServerAliveCountMax = 3;
              HashKnownHosts = false;
              UserKnownHostsFile = "~/.ssh/known_hosts";
              ControlMaster = "no";
              ControlPath = "~/.ssh/master-%r@%n:%p";
              ControlPersist = "no";
            };
            settings."git.ciruzzo.win" = {
              User = "forgejo";
              ProxyCommand = "${lib.getExe pkgs.cloudflared} access ssh --hostname %h";
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
