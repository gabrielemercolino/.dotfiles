{ lib, ... }:
{
  flake.modules.homeManager.helix =
    { pkgs, ... }:
    {
      programs.helix.languages = {
        language-server = {
          nil.command = "${lib.getExe pkgs.nil}";
          bash-language-server.command = "${lib.getExe pkgs.bash-language-server}";
          markdown-oxide.command = "${lib.getExe pkgs.markdown-oxide}";
          yaml-language-server.command = "${lib.getExe pkgs.yaml-language-server}";
        };

        language = [
          {
            name = "nix";
            file-types = [ "nix" ];
            formatter.command = "${lib.getExe pkgs.nixfmt}";
          }
        ];
      };
    };
}
