vim.pack.add({ { src = "https://github.com/DrKJeff16/project.nvim" } })

local project = require("project")
project.setup() -- depends fzf-lua

vim.keymap.set("n", "<leader>p", project.open_menu, { desc = "Open Projects" })
