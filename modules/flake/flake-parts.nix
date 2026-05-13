{ lib, moduleLocation, ... }:

let
  inherit (lib)
    mapAttrs
    mkOption
    types
    ;

  escapeNixIdentifier =
    s: if builtins.match "[a-zA-Z_][a-zA-Z0-9_'\\-]*" s != null then s else lib.escapeNixString s;

  wrapModule = class: moduleName: module: {
    key = "${toString moduleLocation}#modules.${escapeNixIdentifier class}.${escapeNixIdentifier moduleName}";
    _file = "${toString moduleLocation}#modules.${escapeNixIdentifier class}.${escapeNixIdentifier moduleName}";
    _class = class;
    imports = [ module ];
  };
in
{
  # imports = [ inputs.flake-parts.flakeModules.modules ];

  # Basically the same thing but with the key for each module
  options.flake.modules = mkOption {
    type = types.lazyAttrsOf (types.lazyAttrsOf types.deferredModule);
    default = { };
    apply = mapAttrs (class: mapAttrs (wrapModule class));
    description = ''
      Groups of modules published by the flake, with automatic `key` for deduplication.
    '';
  };

}
