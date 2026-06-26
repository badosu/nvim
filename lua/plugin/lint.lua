vim.pack.add({ "https://github.com/stevearc/conform.nvim.git", "https://github.com/mfussenegger/nvim-lint" })

require("plugin.lsp") -- for markdownlint-cli2

local lint = require("lint")

lint.linters_by_ft = {
  markdown = { "markdownlint-cli2" },
}

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWritePost",
  "InsertLeave",
}, {
  callback = function(args)
    -- avoid linting for example diagnostic floats
    if vim.bo[args.buf].buftype == "nofile" then
      return
    end

    lint.try_lint()
  end,
})

require("conform").setup({
  formatters_by_ft = { lua = { "stylua" } },
  format_on_save = function(bufnr)
    -- Check for global or buffer-local disable flag
    if not vim.g.disable_autoformat and not vim.b[bufnr].disable_autoformat then
      return { lsp_format = "fallback" }
    end
  end,
})

vim.keymap.set("n", "\\f", function()
  local bufnr = vim.api.nvim_get_current_buf()

  vim.b[bufnr].disable_autoformat = not vim.b[bufnr].disable_autoformat

  local msg_action = vim.b[bufnr].disable_autoformat and "Disabled" or "Enabled"

  vim.notify(string.format("%s autoformat for buffer", msg_action), vim.log.levels.INFO)
end, { desc = "Toggle autoformat (buffer)" })

vim.keymap.set("n", "\\F", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat

  local msg_action = vim.g.disable_autoformat and "Disabled" or "Enabled"

  vim.notify(string.format("%s autoformat globally", msg_action), vim.log.levels.INFO)
end, { desc = "Toggle autoformat (global)" })
