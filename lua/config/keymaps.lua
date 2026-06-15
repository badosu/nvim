vim.keymap.set("n", "<leader>sm", vim.cmd.messages, { desc = "Messages" })

local min_warn = { severity = { min = vim.diagnostic.severity.WARN } }

vim.keymap.set("n", "<leader>xX", function()
  vim.diagnostic.setqflist(min_warn)
end, { desc = "Put buffer diagnostics to quickfix (WARN)" })

vim.keymap.set("n", "<leader>xx", vim.diagnostic.setqflist, { desc = "Put buffer diagnostics to quickfix" })

vim.keymap.set("n", "<leader>xw", function()
  vim.diagnostic.setqflist(vim.diagnostic.get(nil))
end, { desc = "Put workspace diagnostics to quickfix" })

vim.keymap.set("n", "<leader>xW", function()
  vim.diagnostic.setqflist(vim.tbl_extend("force", vim.diagnostic.get(nil), min_warn))
end, { desc = "Put workspace diagnostics to quickfix (WARN)" })

vim.keymap.set("n", "<leader><tab>d", vim.cmd.tabclose, { desc = "Close tab" })
vim.keymap.set("n", "<leader><tab>n", vim.cmd.tabnew, { desc = "New tab" })

vim.keymap.set("n", "]e", ":m+1<cr>", { desc = "Swap line down" })
vim.keymap.set("n", "[e", ":m-2<cr>", { desc = "Swap line up" })
