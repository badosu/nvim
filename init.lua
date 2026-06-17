-- WARN when adding or removing packs run and replace on .luarc.jsonc
-- :.!ls /home/badosu/.local/share/nvim/site/pack/core/opt | sed 's|^|"$XDG_DATA_HOME/nvim/site/pack/core/opt/|; s|$|",|'

vim.loader.enable(true)

require("vim._core.ui2").enable()

require("config.options")
require("config.events")
require("config.keymaps")
require("config.autocmds")

-- Load plugins ================================================================
local utils = require("utils")

utils.once("BufEnter", function()
  vim.cmd.packadd("nvim.undotree")
end, { desc = "Set up undotree" })

vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

utils.require_on("UIEnter", {
  "plugin.tokyonight",
  "plugin.mini",
  "plugin.lsp",
  "plugin.mise", -- mise MUST run after mason or anything that changes PATH
})

utils.require_on("BufReadPre", { "plugin.treesitter" })
utils.require_on("InsertEnter", { "plugin.completion", "plugin.conform" })

utils.require_on("User", {
  "plugin.neotest",
  "plugin.dap",
  "plugin.gitsigns",
  "plugin.neogit",
}, { pattern = "GitBufOpen" })

utils.require_on("FileType", { "plugin.markdown" }, { pattern = "markdown" })
utils.on("User", function(ev)
  require("plugin.quick_fix")
  vim.api.nvim_del_autocmd(ev.id) -- due to bqf bootstrap
end, { pattern = "QfBufOpen", desc = "Set up quickfix plugins" })
