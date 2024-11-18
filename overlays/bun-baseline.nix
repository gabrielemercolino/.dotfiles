{ pkgs, ... }:
let
  bun = pkgs.bun.overrideAttrs (oldAttrs: {
    passthru.sources."x86_64-linux" = pkgs.fetchurl {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${oldAttrs.version}/bun-linux-x64-baseline.zip";
      hash = "sha256-1nj7pl8sinlf0nz44l539k7m8h6pxyc31qizy2zba3n338c8xnaq";
    };
  });
in
{
  bun = bun;
}
