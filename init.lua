-- PERF  Consider uncommenting below if it ever feels sluggish
vim.loader.enable(true)

require("vim._core.ui2").enable()

_G["Config"] = require("config")
_G["Fn"] = Config.fn

require("config.options")
require("config.events")
require("config.keymaps")
require("config.autocmds")

require("plugin")
