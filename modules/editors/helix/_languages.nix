{
  pkgs,
  lib,
}: {
  language-server = {
    nil.command = "${lib.getExe pkgs.nil}";
    bash-language-server.command = "${lib.getExe pkgs.bash-language-server}";
    elixir-ls.command = "${lib.getExe pkgs.elixir-ls}";
    gopls.command = "${lib.getExe pkgs.gopls}";
    markdown-oxide.command = "${lib.getExe pkgs.markdown-oxide}";
    vscode-css-language-server.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-css-language-server";
    typescript-language-server = {
      command = "${lib.getExe pkgs.typescript-language-server}";
      config = {
        typescript.inlayHints = {
          includeInlayEnumMemberValueHints = true;
          includeInlayFunctionLikeReturnTypeHints = false;
          includeInlayFunctionParameterTypeHints = false;
          includeInlayParameterNameHints = "literals";
          includeInlayParameterNameHintsWhenArgumentMatchesName = true;
          includeInlayPropertyDeclarationTypeHints = false;
          includeInlayVariableTypeHints = false;
        };
      };
    };
    yaml-language-server.command = "${lib.getExe pkgs.yaml-language-server}";
  };

  language = [
    {
      name = "nix";
      file-types = ["nix"];
      formatter.command = "${lib.getExe pkgs.alejandra}";
    }
  ];
}
