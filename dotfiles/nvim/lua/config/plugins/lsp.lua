local util = require("lspconfig.util")

-- Ruff
vim.lsp.config("ruff", {
    cmd = { "ruff", "server" },
    init_options = {
        settings = {
            -- you can add ruff-specific settings here
        },
    },
})

-- Pyright
vim.lsp.config("pyright", {
    settings = {
        pyright = {
            -- Let Ruff handle import organization
            disableOrganizeImports = true,
        },
        python = {
            analysis = {
                -- Ignore all files so Ruff handles linting
                ignore = { "*" },
            },
        },
    },
})

-- Lua LS
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }, -- don’t warn about `vim`
            },
        },
    },
})

-- Nixd
vim.lsp.config("nixd", {
    settings = {
        nixd = {
            formatting = {
                command = { "alejandra" },
            },
        },
    },
})

-- Go (gopls)
vim.lsp.config("gopls", {})


vim.lsp.enable("lua_ls")
vim.lsp.enable("ruff")
vim.lsp.enable("pyright")
vim.lsp.enable("nixd")
vim.lsp.enable("gopls")

-- Keymaps
local keymap = vim.keymap.set
local key_opts = { noremap = true, silent = true }

-- Format buffer with active LSP(s)
keymap("n", "<leader>cf", function()
    vim.lsp.buf.format({
        async = true,
    })
end, vim.tbl_extend("force", key_opts, { desc = "Format buffer with LSP" }))


-- Disable Ruff hover in favor of Pyright
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_attach_disable_ruff_hover", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client and client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
        end
    end,
    desc = "LSP: Disable hover capability from Ruff",
})
