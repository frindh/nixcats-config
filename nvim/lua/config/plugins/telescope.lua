local telescope = require("telescope")
telescope.setup({})

-- protected call since telescope extensions are optional,
-- if fzf is not available neovim will not crash
pcall(telescope.load_extension("fzf"))

local builtin = require('telescope.builtin')
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Files
keymap('n', '<leader>ff', builtin.find_files, opts)
keymap('n', '<leader>fr', builtin.oldfiles, opts) -- recent files
keymap('n', '<leader>fg', builtin.live_grep, opts)
keymap('n', '<leader>fb', builtin.buffers, opts)
keymap('n', '<leader>fh', builtin.help_tags, opts)

-- Git
keymap('n', '<leader>gc', builtin.git_commits, opts)
keymap('n', '<leader>gb', builtin.git_branches, opts)
keymap('n', '<leader>gs', builtin.git_status, opts)

-- Misc
keymap('n', '<leader>fm', builtin.man_pages, opts) -- Man pages
keymap('n', '<leader>fk', builtin.keymaps, opts)   -- List keymaps
keymap('n', '<leader>fc', builtin.commands, opts)  -- Vim commands
keymap('n', '<leader>ft', builtin.builtin, opts)   -- List all Telescope pickers
