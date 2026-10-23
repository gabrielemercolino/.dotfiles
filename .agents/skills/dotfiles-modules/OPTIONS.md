# Options

All own options live under `gab.*`. Enable flags use `mkEnableOption` + `mkIf`:

```nix
options.gab.cli.foo = { enable = lib.mkEnableOption "foo"; };
config = lib.mkIf cfg.enable { ... };
```
