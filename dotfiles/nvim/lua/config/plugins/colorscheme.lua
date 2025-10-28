local kanagawa = require("kanagawa")

kanagawa.setup({
    theme = "lotus",
    colors = {
        theme = {
            all = {
                ui = {
                    bg_gutter = "none"
                }
            }
        }
    }
})

-- load the colorscheme
vim.cmd("colorscheme kanagawa")
