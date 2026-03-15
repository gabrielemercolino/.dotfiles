{
  self,
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mapAttrs;

  # TODO: check if it's actually working as expected
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

      theme = mkOption {
        type = themeType;
      };

      user = {
        name = mkOption {
          type = types.str;
          default = "user";
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

  config = {
    flake.nixosConfigurations = mapAttrs (
      name: host:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [ host.nixos ];
        specialArgs = {
          inherit (host) theme user;
        };
      }
    ) config.hosts;

    flake.homeConfigurations = mapAttrs (
      name: host:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs { system = host.system; };
        modules = [ host.home ];
        extraSpecialArgs = {
          inherit (host) theme user;
        };
      }
    ) config.hosts;
  };
}
