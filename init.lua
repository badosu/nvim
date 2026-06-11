require("vim._core.ui2").enable()

require("config.options")

if vim.g.neovide then
  require("config.neovide")
end

local util = require("util")

util.require_on("VimEnter", {
  "plugin.core",
  "plugin.tokyonight",
  "plugin.mise",
  "plugin.lsp",
  "plugin.conform",
  "plugin.fzf_lua",
  "plugin.mini_icons", -- depends: mason or whatever lsp stuff
  "plugin.mini_notify",
  "plugin.bufferline",
  "plugin.project",
  "plugin.oil",
  "plugin.completion",
  "config.statusline", -- depends: tokyonight
  "plugin.which_key",
})

util.require_on("BufReadPre", {
  "plugin.gitsigns",
})

require("config.keymaps")
