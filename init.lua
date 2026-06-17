-- WARN  When adding or removing packs run and replace on .luarc.jsonc
-- .!ls /home/badosu/.local/share/nvim/site/pack/core/opt | sed 's|^|"$XDG_DATA_HOME/nvim/site/pack/core/opt/|; s|$|",|'

-- PERF  Consider uncommenting below if it ever feels sluggish
-- vim.loader.enable(true)

require("vim._core.ui2").enable()

Config = require("config")

require("config.options")
require("config.events")
require("config.keymaps")
require("config.autocmds")

Config.once("BufEnter", function()
  vim.cmd.packadd("nvim.undotree")
end, { desc = "Set up undotree" })

require("plugin")
