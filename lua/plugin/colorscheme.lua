vim.pack.add({ "https://github.com/rebelot/kanagawa.nvim" })

require("kanagawa").setup({
  dimInactive = true, -- dim inactive window `:h hl-NormalNC`
  theme = "dragon",
  background = { -- map the value of 'background' option to a theme
    dark = "dragon",
  },
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
  overrides = function(colors)
    local theme = colors.theme
    return {
      WinSeparator = { fg = theme.ui.nontext }, -- brighter
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },
    }
  end,
})

vim.cmd.colorscheme("kanagawa")

-- vim.pack.add({ { src = "https://github.com/folke/tokyonight.nvim" } })
--
-- ---@diagnostic disable-next-line: missing-fields
-- require("tokyonight").setup({
--   style = "night",
-- })
--
-- vim.cmd.colorscheme("tokyonight")
--
-- local c = require("tokyonight.colors.night")
--
-- vim.api.nvim_set_hl(0, "PmenuBorder", { fg = c.border_highlight, bg = c.bg_float })
