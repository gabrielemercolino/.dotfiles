---
name: writing-modules
description: Conventions for writing Nix modules in this dotfiles repo (flake-parts + import-tree dendritic structure, collectors, adapters, hosts, splitting). Use when adding, moving, or editing anything under ./modules.
---

# Writing modules

This repo uses the dendritic pattern: `flake-parts` + `import-tree` (`flake.nix`),
where **every `.nix` file under `./modules` is a flake-parts module**. This is the
contract for writing them.

## Layout

```
modules/
  flake/            flake-parts infrastructure (hosts option, devshell, treefmt, systems)
  nixos/            NixOS modules → class "nixos"
    core/           always-on core (force-imported)
    <collector>/    one directory per collector
    style.nix       standalone module (no collector)
  home/             home-manager modules → class "homeManager"
    core/
    <collector>/
    style.nix
    shells/default.nix   standalone "shell" module (dir used to co-locate assets)
  hosts/            one directory per host; each sets hosts.<name>
  packages/         flake packages (perSystem)
themes/<name>/      styling themes, consumed by the style modules
```

## How a file becomes a module

`import-tree ./modules` imports every `*.nix` under `modules/` as a flake-parts
module. Paths containing `/_` are ignored (eg. `_hardware-configuration.nix`).

`modules/flake/flake-parts.nix` declares the registry option `flake.modules`
(type `lazyAttrsOf (lazyAttrsOf deferredModule)`) and wraps each entry with
`key` / `_file` / `_class` so the NixOS/HM module system deduplicates it.
flake-parts exposes it as `self.modules` (= `config.flake.modules`).

A file publishes a module like this:

```nix
{ self, lib, ... }:
{
  flake.modules.nixos.<name> = { config, pkgs, ... }: { ... };  # or homeManager
}
```

Two classes exist: `nixos` and `homeManager`. The `modules/nixos` vs
`modules/home` split is only for navigation, the class is whatever you write in
`flake.modules.*`.

**Names are flat and unique per class.** `flake.modules.nixos.bashmount` (lives
in `cli/`) and `flake.modules.nixos.kernel` (lives in `core/`) are siblings: the
directory does not namespace the module. Never reuse a name within a class.

## The two function layers

Every module file has an outer flake-parts function and an inner NixOS/HM module:

- outer: `{ self, inputs, lib, ... }` — builds the `flake.modules.*` declaration
  (or `perSystem` for packages/devshell).
- inner: `{ config, pkgs, ... }` plus specialArgs if needed.

If inputs in the outer scope are needed in the inner scoper reach them by closure.
See `modules/nixos/login/sddm.nix` for an example.

specialArgs are defined by `mkSpecialArgs` in `modules/flake/hosts.nix`.
Treat that file as the authoritative source and check it before relying on a name
(this list can drift).

## Options namespace

All own options live under `gab.*`. Enable flags use `mkEnableOption` + `mkIf`:

```nix
options.gab.cli.foo = { enable = lib.mkEnableOption "foo"; };
config = lib.mkIf cfg.enable { ... };
```

## Collectors

A collector is a module whose only job is to import a group of modules. Each
member registers itself into its collector:

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
  Exception: `nixos.hm` is an **adapter** collector for the nixos
  side of adapters (see below); hosts.nix imports it automatically when the host
  has `home`.
- Standalone modules (no collector) set `flake.modules.<class>.<name> = <module>`
  directly and are imported by name in hosts. Examples: `style`, `shell`.

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
referenced by relative path — import-tree ignores them
(`modules/home/cli/pi/APPEND_SYSTEM.md`, `modules/home/shells/oh-my-posh.yaml`).

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
See `modules/home/wm/hyprland/default.nix`.

## Hosts

`modules/hosts/<host>/default.nix` sets `hosts.<host>` (option declared in
`modules/flake/hosts.nix`). Hosts are auto-discovered by import-tree.

```nix
{ self, lib, ... }:
let
  inherit (self.modules) nixos homeManager;
in
{
  hosts.<host> = {
    system = "x86_64-linux";
    audio = "pipewire";
    theme = "roathe-dark";
    performance = "medium";
    localization = {
      keyboard.layout = "it";
      keyboard.variant = "";
      locale = "it_IT.UTF-8";
      time.zone = "Europe/Rome";
      time.hardware-clock.enable = false;
    };
    user = { name = "gabriele"; email = "..."; };

    nixos = { pkgs, user, ... }: {
      imports = with nixos; [
        ./_hardware-configuration.nix
        style
        # collectors...
      ];
      gab.<collector>.<name>.enable = true;  # turn features on here
    };

    home = { pkgs, user, host, ... }: {   # can be omitted
      imports = with homeManager; [
        style
        shell
        # collectors...
      ];
      gab.<collector>.<name>.enable = true;
    };
  };
}
```

- `nixos` and `home` are `deferredModule`s, so a host's config can be split
  across several files that each set `hosts.<host>.nixos = {...}` (they merge).
  See `modules/hosts/home-server/`.
- `_`-prefixed files are invisible to import-tree; import them explicitly.
  Importing by path is rare. `_hardware-configuration.nix` is one such case.
- `home` is optional (`types.nullOr deferredModule`, defaults to null): omit it
  for a NixOS-only host. Every current host sets it, but the option supports the
  headless case.
- Don't set `system.stateVersion` / `home.stateVersion`, hosts.nix defaults them.

## Packages & other flake-parts outputs

- `modules/packages/<name>.nix` → `perSystem.packages.<name>`.
- `modules/flake/*` → infrastructure (hosts option, devshell, treefmt, systems).
- `perSystem` can also build a package alongside a module
  (`modules/home/core/gab/default.nix`).

## Rules summary

1. Outer fn `{ self, inputs, lib, ... }`; inner `{ config, pkgs, ... }` +
   specialArgs. Get `inputs`/`self`/`lib` via closure.
2. Own options under `gab.*`; enable flags via `mkEnableOption` + `mkIf`.
3. Collector = dir + `<collector>.imports = [...]`; members register themselves.
   Collectors are a host convenience, not required. Hosts may import modules by
   name too.
4. Core is always imported, omit it in hosts. `nixos.hm` is auto imported when
   `home != null`.
5. Default to single `<name>.nix`; split via `default.nix` + siblings setting the
   same `flake.modules.<class>.<name>`.
6. Module names are flat and unique per class.
7. Adapters: nixos side named `<name>-hm` in the `hm` collector, hm side owns the
   option.
8. Hosts split via multiple `hosts.<host>.nixos/home = {...}` files; prefix files
   with `_` to opt out of import-tree.
