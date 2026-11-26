{ inputs, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;

  pathList = mkOption {
    type = types.listOf (types.either types.str (types.attrsOf types.anything));
    default = [ ];
    description = ''
      Paths (or preservation attrsets like { directory = "..."; inInitrd = true; })
      to keep across reboots.
    '';
  };
in
{
  flake.modules.nixos.preservation =
    { config, ... }:
    let
      cfg = config.gab.preservation;

      # state every NixOS install needs to keep its identity across boots
      baseDirectories = [
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
        # /tmp on disk, not in RAM.
        {
          directory = "/tmp";
          mode = "1777";
        }
        "/etc/ssh"
        "/etc/NetworkManager/system-connections"
        "/var/lib/NetworkManager"
      ];

      baseFiles = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
    in
    {
      imports = [ inputs.preservation.nixosModules.default ];

      options.gab.preservation = {
        enable = mkEnableOption "impermanent root (tmpfs / with declared state on a persistent volume)";

        directories = pathList;
        files = pathList;
      };

      config = mkIf cfg.enable {
        fileSystems."/nix".neededForBoot = true;
        fileSystems."/persistent".neededForBoot = true;

        boot.tmp.cleanOnBoot = true;

        preservation = {
          enable = true;

          preserveAt."/persistent" = {
            directories = baseDirectories ++ cfg.directories;
            files = baseFiles ++ cfg.files;
          };
        };
      };
    };
}
