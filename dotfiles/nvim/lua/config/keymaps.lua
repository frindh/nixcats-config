local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- jk to exit insert mode
keymap("i", "jk", "<ESC>", opts)

