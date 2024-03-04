{ config, pkgs, systemSettings, userSettings, ... }:

{
	programs.neovim = 
	let
    	toLua = str: "lua << EOF\n${str}\nEOF\n";
    	toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";
  	in
  	{
		enable = true;

		viAlias = true;
		vimAlias = true;
		vimdiffAlias = true;

    	extraPackages = with pkgs; [
    		lua-language-server
			rnix-lsp
  			xclip
      		wl-clipboard
    	];

		plugins = with pkgs.vimPlugins; [
			{
				plugin = comment-nvim;
				config = toLua "require(\"Comment\").setup()";
			}

			#{
			#	plugin = gruvbox-nvim;
			#	config = "colorscheme gruvbox";
			#}

			{
				plugin = tokyonight-nvim;
				config = "colorscheme tokyonight";
			}

			{
				plugin = lualine-nvim;
				config = toLuaFile ./nvim/plugins/lualine.lua;
			}

			neodev-nvim

			nvim-treesitter.withAllGrammars
    	];

    	extraLuaConfig = ''
      		${builtins.readFile ./nvim/options.lua}
    	'';
	};
}
