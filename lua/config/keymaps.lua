vim.keymap.set("n", "<leader>sm", vim.cmd.messages, { desc = "Messages" })

local min_warn = { severity = { min = vim.diagnostic.severity.WARN } }

vim.keymap.set("n", "<leader>xX", function()
  vim.diagnostic.setqflist(min_warn)
end, { desc = "Put buffer diagnostics to quickfix (WARN)" })

vim.keymap.set("n", "<leader>xx", function()
  vim.diagnostic.setqflist()
end, { desc = "Put buffer diagnostics to quickfix" })

-- Alternatively, send all workspace diagnostics to quickfix
vim.keymap.set("n", "<leader>xw", function()
  vim.diagnostic.setqflist(vim.diagnostic.get(nil))
end, { desc = "Put workspace diagnostics to quickfix" })

vim.keymap.set("n", "<leader>xW", function()
  vim.diagnostic.setqflist(vim.tbl_extend("force", vim.diagnostic.get(nil), min_warn))
end, { desc = "Put workspace diagnostics to quickfix (WARN)" })
