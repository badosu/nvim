vim.pack.add({ { src = "https://github.com/nvim-mini/mini.notify" } })

local mini_notify_window = function()
  local has_statusline = vim.o.laststatus > 0
  local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
  return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
end

require("mini.notify").setup({
  window = { config = mini_notify_window },
  lsp_progress = {
    -- Whether to enable showing
    enable = true,
  },
})
