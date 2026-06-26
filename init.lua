-- PERF  Consider uncommenting below if it ever feels sluggish
vim.loader.enable(true)

require("vim._core.ui2").enable()

--- Creates a closure that invokes `f` with the provided arguments.
---
--- The returned function ignores any arguments passed to it and always calls
--- `f` with the arguments captured when `fn` was created.
---
---@generic R
---@param f fun(...): R Function to invoke.
---@param ... any Arguments to capture and pass to `f`.
---@return fun(): R
function Fn(f, ...)
  local args = { ... }
  return function()
    return f(unpack(args))
  end
end

Config = require("config")

require("config.options")
require("config.events")
require("config.keymaps")
require("config.autocmds")

Config.once("BufEnter", Fn(vim.cmd.packadd, "nvim.undotree"), { desc = "Set up undotree" })

require("plugin")
