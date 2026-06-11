vim.pack.add({ { src = "https://github.com/ibhagwan/fzf-lua" } })

local fzf = require("fzf-lua")
fzf.setup({})

vim.keymap.set("n", "<leader>sf", fzf.git_files, { desc = "Search repo files" })
vim.keymap.set("n", "<leader>sg", fzf.grep_project, { desc = "Grep repo files" })
vim.keymap.set("n", "<leader>sb", fzf.buffers, { desc = "Pick buffer" })
vim.keymap.set("n", "<leader>sm", fzf.builtin, { desc = "Open Picker menu" })
vim.keymap.set("n", "<leader><leader>", fzf.global, { desc = "Global Search" })
