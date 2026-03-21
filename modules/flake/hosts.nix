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
  themeType = types.enum (
    builtins.readDir themeDir
    |> builtins.attrNames
    |> builtins.filter (name: lib.strings.hasSuffix ".nix" name)
    |> map (lib.removeSuffix ".nix")
  );

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

      theme = mkOption {
        type = themeType;
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
        type = types.deferredModule;
        default = { };
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

      baseHost = rec {
        stateVersion = "26.05";

        nixos = {
          imports = with modules.nixos; [ core ];
          system.stateVersion = mkDefault stateVersion;
        };

        home = {
          imports = with modules.homeManager; [ core ];
          home.stateVersion = mkDefault stateVersion;
        };
      };

      # utility that makes the theme usage easier for the external modules
      themeFn =
        host:
        {
          pkgs,
          lib,
          config,
        }:
        import (self.outPath + "/themes/${host.theme}.nix") {
          inherit config lib pkgs;
        };
    in
    {
      flake.nixosConfigurations = mapAttrs (
        name: host:
        inputs.nixpkgs.lib.nixosSystem {
          modules = [
            baseHost.nixos
            {
              users.users.${host.user.name} = {
                isNormalUser = true;
                description = host.user.name;
                extraGroups = [ "wheel" ];
              };

              services.getty.autologinUser = mkDefault host.user.name;
            }
            host.nixos
          ];
          specialArgs = {
            inherit (host)
              audio
              user
              localization
              ;
            host.name = name;
            loadTheme = themeFn host;
          };
        }
      ) config.hosts;

      flake.homeConfigurations = mapAttrs (
        name: host:
        inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs { system = host.system; };
          modules = [
            baseHost.home
            host.home
          ];
          extraSpecialArgs = {
            inherit (host)
              audio
              user
              localization
              ;
            host.name = name;
            loadTheme = themeFn host;
          };
        }
      ) config.hosts;
    };
}
