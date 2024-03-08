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
      todo-comments-nvim

      gitsigns-nvim
      diffview-nvim

			{
				plugin = comment-nvim;
				config = toLua "require(\"Comment\").setup()";
			}

      {
			#	plugin = monokai-pro-nvim; 
			#	config = "colorscheme monokai-pro";

      #	plugin = tokyonight-nvim;
			#	config = "colorscheme tokyonight";

      	plugin = gruvbox-nvim;
				config = "colorscheme gruvbox";

			}

			{
				plugin = lualine-nvim;
				config = toLuaFile ./nvim/plugins/lualine.lua;
			}

			nvim-web-devicons

			neodev-nvim

      nvim-treesitter.withAllGrammars
      nvim-treesitter-textobjects
      nvim-treesitter-endwise

			{
				plugin = telescope-nvim;
				config = toLuaFile ./nvim/plugins/telescope.lua;
			}

      telescope-symbols-nvim
      telescope-fzf-native-nvim
      
      {
        plugin = neo-tree-nvim;
        config = toLuaFile ./nvim/plugins/neotree.lua;
      }

      {
        plugin = which-key-nvim;
        config = toLuaFile ./nvim/plugins/whichkey.lua;
      }
    ];

    extraLuaConfig = ''
      		${builtins.readFile ./nvim/options.lua}
    '';
	};
}
