{
  description = "My flake";

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    nixpkgs.url = "nixpkgs/3ec636362e1816bc2f0888fa0fa2c69f1bc9e504";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    hyprnix = {
      url = "github:Nyramu/hyprnix";
      # url = "path:/home/gabriele/dev/nix/hyprnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    umbriel.url = "github:noctalia-dev/umbriel/cachix";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      # url = "path:/home/gabriele/dev/nix/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags-bar = {
      url = "github:gabrielemercolino/ags-bar";
      # url = "path:/home/gabriele/dev/others/ags-bar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  nixConfig = {
    extra-substituters = [
      "https://playit-nixos-module.cachix.org"
      "https://cache.lantian.pub/lantian"
      "https://hyprland.cachix.org"
      "https://umbriel.cachix.org"
    ];
    extra-trusted-public-keys = [
      "playit-nixos-module.cachix.org-1:22hBXWXBbd/7o1cOnh+p0hpFUVk9lPdRLX3p5YSfRz4="
      "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };
}
