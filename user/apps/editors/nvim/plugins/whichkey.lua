-- redundant but just to be sure
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local wk = require("which-key")

local neotree = {
  ["<leader>e"] = {"<cmd>Neotree toggle<cr>", "Toggle Neotree"},
} 

local telescope = {
  ["<leader>f"] = {
    name = "+file",
    f = { "<cmd>Telescope find_files<cr>", "Find File" },
  }
}

wk.register(neotree)
wk.register(telescope)
