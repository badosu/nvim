require("vim._core.ui2").enable()

require("config.options")

if vim.g.neovide then
  require("config.neovide")
end

local util = require("util")

-- WARN: when adding or removing packs run and replace on .luarc.jsonc
-- ls /home/badosu/.local/share/nvim/site/pack/core/opt | sed 's|^|"$XDG_DATA_HOME/nvim/site/pack/core/opt/|; s|$|",|'

util.require_on("VimEnter", {
  "plugin.core",
  "plugin.tokyonight",
  "plugin.treesitter",
  "plugin.mise",
  "plugin.lsp",
  "plugin.conform",
  "plugin.completion",
  "plugin.gitsigns",
  "plugin.neotest",
  "plugin.dap",
  "config.statusline", -- depends: tokyonight
})

require("config.keymaps")
