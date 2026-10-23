---
name: dotfiles-modules
description: Conventions for writing Nix modules in this dotfiles repo. Use when exploring, adding, moving, or editing any nix related file.
---

# Dotfiles modules

This repo uses the dendritic pattern: `flake-parts` + `import-tree`,
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
  hosts/            one directory per host; each sets hosts.<name>
  packages/         flake packages (perSystem)
themes/<name>/      styling themes, consumed by the style modules
```

## Basics

`import-tree ./modules` imports every `*.nix` under `modules/` as a flake-parts
module. Paths containing `/_` are ignored (eg. `_hardware-configuration.nix`).

`modules/flake/flake-parts.nix` declares the registry option `flake.modules`
and wraps each entry so the NixOS/HM module system deduplicates it.

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

**Names are flat and unique per class.** `flake.modules.nixos.bashmount`
and `flake.modules.nixos.kernel` are siblings: the directory does not namespace the module.
Never reuse a name within a class.

## Outer and inner scope

Every module file has an outer flake-parts function and an inner NixOS/HM module:

- outer: `{ self, inputs, lib, ... }` — builds the `flake.modules.*` declaration
  (or `perSystem` for packages/devshell).
- inner: `{ config, pkgs, ... }` plus specialArgs if needed.

If inputs in the outer scope are needed in the inner scope, reach them by closure.
See `modules/nixos/login/sddm.nix` for an example.

specialArgs are defined by `mkSpecialArgs` in `modules/flake/hosts.nix`.
Treat that file as the authoritative source and check it before relying on a name.

## Options namespace

For rules about option definitions see `./OPTIONS.md`.

## Collectors

A collector is a module whose only job is to import a group of modules.
See `./COLLECTORS.md` for more info. 

## Hosts

For rules about hosts definitions see `./HOSTS.md`.

## Packages & other outputs

For rules about packages & other outputs see `./OTHERS.md`
