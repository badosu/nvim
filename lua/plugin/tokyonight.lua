vim.pack.add({ { src = "https://github.com/folke/tokyonight.nvim" } })

---@diagnostic disable-next-line: missing-fields
require("tokyonight").setup({
  style = "night",
})

vim.cmd.colorscheme("tokyonight")

local c = require("tokyonight.colors.night")

vim.api.nvim_set_hl(0, "PmenuBorder", { fg = c.border_highlight, bg = c.bg_float })
