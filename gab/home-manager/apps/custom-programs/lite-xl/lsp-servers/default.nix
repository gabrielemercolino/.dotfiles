{ pkgs, stdenv }:
let
  generateLspConfig =
    { name, command }:
    # lua
    ''
      lspconfig.${name}.setup {
        command = { "${command}" }
      }
    '';

  mkLspServer =
    { name, command }:
    stdenv.mkDerivation {
      inherit name;
      src = null;
      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out/share
        echo '
        -- mod-version:3
        local lspconfig = require "plugins.lsp.config"

        ${generateLspConfig { inherit name command; }}
        ' > $out/share/${name}_lsp.lua 
      '';
    };
in
{

  rust_analyzer = mkLspServer {
    name = "rust_analyzer";
    command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  };

  nil = mkLspServer {
    name = "nillsp";
    command = "${pkgs.nil}/bin/nil";
  };

}
