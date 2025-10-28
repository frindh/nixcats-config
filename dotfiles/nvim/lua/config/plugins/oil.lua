local oil = require("oil")

oil.setup({})

-- Open Oil in  current buffer
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

--   dependencies = { { "echasnovski/mini.icons", opts = {} } },
