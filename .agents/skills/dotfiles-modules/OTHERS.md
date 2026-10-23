# Others

- `modules/packages/<name>.nix` → `perSystem.packages.<name>`.
- `modules/flake/*` → infrastructure (hosts option, devshell, treefmt, systems).
- `perSystem` can also build a package alongside a module.
  Example: `modules/home/core/gab/default.nix`.
