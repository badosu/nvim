vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
})

local oil = require("oil")
oil.setup()
vim.keymap.set("n", "-", oil.open, { desc = "Open parent directory" })
