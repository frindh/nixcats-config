-- Set custom indentation for filetype
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "yaml", "html", "css", "nix" },
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
})
