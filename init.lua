-- WARN when adding or removing packs run and replace on .luarc.jsonc
-- :.!ls /home/badosu/.local/share/nvim/site/pack/core/opt | sed 's|^|"$XDG_DATA_HOME/nvim/site/pack/core/opt/|; s|$|",|'

require("vim._core.ui2").enable()

require("config.options")

if vim.g.neovide then
  require("config.neovide")
end

require("config.events")
require("config.keymaps")
require("config.autocmds")

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

local util = require("util")

-- Load plugins ================================================================
util.require_on("VimEnter", {
  "plugin.core",
  "plugin.tokyonight",
  "plugin.lsp",
  "plugin.mise", -- mise MUST run after mason or anything that changes PATH
  "plugin.better_quick_fix",
  "config.statusline", -- depends: tokyonight, gitsigns
})

util.require_on("BufReadPre", {
  "plugin.treesitter",
  "plugin.completion",
  "plugin.conform",
  "plugin.neotest",
  "plugin.dap",
})

util.require_on("User", {
  "plugin.gitsigns",
  "plugin.neogit",
}, { pattern = "GitBufOpen" })
