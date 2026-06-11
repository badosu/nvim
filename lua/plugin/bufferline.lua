vim.pack.add({ { src = "https://github.com/akinsho/bufferline.nvim" } })

local bufferline = require("bufferline")
bufferline.setup()

vim.keymap.set("n", "H", function()
  bufferline.cycle(-1)
end, { desc = "Cycle previous buffer" })

vim.keymap.set("n", "L", function()
  bufferline.cycle(1)
end, { desc = "Cycle next buffer" })
