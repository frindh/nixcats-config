-- lua/config/init.lua
require('config.options')
require('config.keymaps')
require("config.autocmds")
require("config.plugins.oil")
require("config.plugins.colorscheme")
require("config.plugins.telescope")

-- Only load LSP if the category is enabled
if nixCats('lsp') then
    require("config.plugins.lsp")
end

-- Only load treesitter if enabled
if nixCats('treesitter') then
    require("config.plugins.treesitter")
end







