# Hosts

`modules/hosts/<host>/default.nix` sets `hosts.<host>` (declared in
`modules/flake/hosts.nix`). Hosts are auto-discovered by `import-tree`.

Example:

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
    user = { name = "..."; email = "..."; };

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
  Example: `modules/hosts/home-server/`.
- Importing by path is rare. `_hardware-configuration.nix` is one such case.
- `home` is optional: omit it for a NixOS-only host.
  Every current host sets it, but the option supports the headless case.
- `modules/flake/hosts.nix` has some defaults already set.
