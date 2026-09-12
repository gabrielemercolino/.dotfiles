{
  self,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkDefault
    types
    mapAttrs
    ;

  themeDir = self.outPath + "/themes";
  themeType = types.enum (builtins.readDir themeDir |> builtins.attrNames);

  hostType = types.submodule {
    options = {
      system = mkOption {
        type = types.str;
        default = "x86_64-linux";
      };

      audio = mkOption {
        type = types.nullOr (
          types.enum [
            "pulseaudio"
            "pipewire"
          ]
        );
        default = null;
      };

      performance = mkOption {
        type = types.enum [
          "low"
          "medium"
          "high"
        ];
        default = "medium";
      };

      theme = mkOption {
        type = types.nullOr themeType;
        default = null;
      };

      user = {
        name = mkOption {
          type = types.str;
          default = "user";
        };

        email = mkOption {
          type = types.str;
          default = "";
        };
      };

      localization = {
        keyboard = {
          layout = mkOption {
            type = types.str;
            example = "it";
          };

          variant = mkOption {
            type = types.str;
            default = "";
            example = "nodeadkeys";
          };
        };

        locale = mkOption {
          type = types.str;
          example = "en_US.UTF-8";
        };

        time = {
          zone = mkOption {
            type = types.str;
            example = "America/New_York";
          };
          hardware-clock.enable = mkEnableOption "hardware clock (for dual boot)";
        };
      };

      nixos = mkOption {
        type = types.deferredModule;
        default = { };
      };

      home = mkOption {
        type = types.nullOr types.deferredModule;
        default = null;
      };
    };
  };
in
{
  options.hosts = mkOption {
    type = types.attrsOf hostType;
    default = { };
  };

  config =
    let
      inherit (config.flake) modules;

      mkSpecialArgs = name: host: {
        inherit self;
        inherit (host) audio user localization;
        host = {
          inherit name;
          inherit (host) system theme performance;
        };
      };

      baseHost = rec {
        stateVersion = "26.11";

        nixos = name: host: {
          imports = [
            modules.nixos.core
          ]
          ++ [ host.nixos ]
          ++ lib.optional (host.home != null) modules.nixos.hm;

          system.stateVersion = mkDefault stateVersion;
        };

        home = name: host: {
          imports = [ inputs.home-manager.nixosModules.home-manager ];

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = mkSpecialArgs name host;
            users.${host.user.name}.imports = [
              {
                imports = with modules.homeManager; [ core ];
                home.stateVersion = mkDefault stateVersion;
              }
              host.home
            ];
          };
        };
      };
    in
    {
      flake.nixosConfigurations = mapAttrs (
        name: host:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            (baseHost.nixos name host)
            (baseHost.home name host)
          ];
          specialArgs = mkSpecialArgs name host;
        }
      ) config.hosts;
    };
}
