# Collectors

A collector is a module whose only job is to import a group of modules.
Each member registers itself into its collector:

```nix
{ self, lib, ... }:
{
  flake.modules.nixos = {
    <collector>.imports = [ self.modules.nixos.<name> ];

    <name> =
      { config, pkgs, ... }:
      let
        cfg = config.gab.<...>;
      in
      {
        options.gab.<...> = { enable = lib.mkEnableOption "..."; };
        config = lib.mkIf cfg.enable { ... };
      };
  };
}
```

Rules:

- **Collectors are a convenience for hosts, not enforced.** Hosts usually import
  collectors (`imports = with nixos; [ cli gaming ... ]`), but may import a
  specific module by name instead.
- A module that needs another module imports the specific module
  `self.modules.<class>.<name>`, not a collector.
- A collector usually maps to a directory `modules/<class>/<collector>/`.
  This does not apply for *adapters* (see below).
- Standalone modules (no collector) are allowed. Examples: `style`, `shell`.

## Core (always on)

`nixos.core` and `homeManager.core` are force-imported in
`modules/flake/hosts.nix`. Omit them from host imports and put always-on modules
in `core/`. Adapters are also auto-added when needed.

## Single file vs split

Default to a single `<name>.nix` in the collector dir. Split only when it grows:

- `default.nix` — the main part: registers the collector import **and** defines
  options/main config.
- sibling files — set `flake.modules.<class>.<name> = <module>` directly (no
  collector import). They merge into the same module (`types.deferredModule`
  merges).

```nix
# modules/home/<collector>/<name>/default.nix
{ self, lib, ... }:
{
  flake.modules.homeManager = {
    <collector>.imports = [ self.modules.homeManager.<name> ];

    <name> =
      { config, pkgs, ... }:
      let
        cfg = config.gab.<...>;
      in
      {
        options.gab.<...> = { enable = lib.mkEnableOption "..."; };
        config = lib.mkIf cfg.enable { ... };
      };
  };
}

# modules/home/<collector>/<name>/extra.nix  (merges into <name>)
{ lib, ... }:
{
  flake.modules.homeManager.<name> =
    { config, pkgs, ... }:
    {
      # additional config
    };
}
```

Non-`.nix` assets (`.yaml`, `.md`, …) can live next to the module and be
referenced by relative path, `import-tree` ignores them.
Example: `modules/home/shells/oh-my-posh.yaml`.

## Adapters (bridging NixOS + home-manager)

When one feature needs both system-level and user-level options, write both sides
in one place and register the nixos side in the adapter `hm` collector:

```nix
# modules/home/<collector>/<name>/default.nix
{ self, inputs, lib, ... }:
{
  # NixOS side → nixos.hm (auto-imported)
  flake.modules.nixos = {
    hm.imports = [ self.modules.nixos.<name>-hm ];

    <name>-hm =
      { config, user, ... }:
      let
        cfg = config.home-manager.users.${user.name}.gab.<...> or { enable = false; };
      in
      {
        config = lib.mkIf cfg.enable { /* system bits */ };
      };
  };

  # home-manager side → owns the option
  flake.modules.homeManager = {
    <collector>.imports = [ self.modules.homeManager.<name> ];

    <name> =
      { config, pkgs, ... }:
      let
        cfg = config.gab.<...>;
      in
      {
        options.gab.<...> = { enable = lib.mkEnableOption "..."; };
        config = lib.mkIf cfg.enable { /* user bits */ };
      };
  };
}
```

The host imports only the HM collector; the nixos side arrives via `nixos.hm`.
Example: `modules/home/wm/hyprland/default.nix`.
