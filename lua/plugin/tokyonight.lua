vim.pack.add({ { src = "https://github.com/folke/tokyonight.nvim" } })
vim.cmd.colorscheme("tokyonight-night")

local c = require("tokyonight.colors.night")
vim.api.nvim_set_hl(0, "PmenuBorder", { fg = c.border_highlight, bg = c.bg_float })
