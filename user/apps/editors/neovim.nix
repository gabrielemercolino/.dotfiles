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

			#{
			#	plugin = tokyonight-nvim;
			#	config = "colorscheme tokyonight";
			#}

			{
				plugin = monokai-pro-nvim; 
				config = "colorscheme monokai-pro";
			}

			{
				plugin = lualine-nvim;
				config = toLuaFile ./nvim/plugins/lualine.lua;
			}

      nvim-web-devicons

			neodev-nvim

			nvim-treesitter.withAllGrammars

			{
				plugin = telescope-nvim;
				config = toLuaFile ./nvim/plugins/telescope.lua;
			}

			telescope-fzf-native-nvim

    ];

    	extraLuaConfig = ''
      		${builtins.readFile ./nvim/options.lua}
    	'';
	};
}
