local min_warn = { severity = { min = vim.diagnostic.severity.WARN } }

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

vim.keymap.set("n", "n", "nzz", { desc = "Find next match and center" })
vim.keymap.set("n", "N", "Nzz", { desc = "Find previous match and center" })

local put_diag_qf_warn = Fn(vim.diagnostic.setqflist, min_warn)
vim.keymap.set("n", "<leader>xX", put_diag_qf_warn, { desc = "Put buffer diagnostics to quickfix (WARN)" })

vim.keymap.set("n", "<leader>xx", vim.diagnostic.setqflist, { desc = "Put buffer diagnostics to quickfix" })

vim.keymap.set("n", "<leader>xw", function()
  vim.diagnostic.setqflist(vim.diagnostic.get(nil))
end, { desc = "Put workspace diagnostics to quickfix" })

vim.keymap.set("n", "<leader>xW", function()
  vim.diagnostic.setqflist(vim.tbl_extend("force", vim.diagnostic.get(nil), min_warn))
end, { desc = "Put workspace diagnostics to quickfix (WARN)" })

vim.keymap.set("n", "<tab>q", vim.cmd.tabclose, { desc = "Close tab" })
vim.keymap.set("n", "<tab>n", vim.cmd.tabnew, { desc = "New tab" })
vim.keymap.set("n", "<tab>t", ":tab terminal<cr>", { desc = "Open terminal in new tab" })

vim.keymap.set("n", "]e", ":m+1<cr>", { desc = "Swap line down" })
vim.keymap.set("n", "[e", ":m-2<cr>", { desc = "Swap line up" })

Config.on("FileType", function(ev)
  vim.keymap.set("n", "q", vim.cmd.cclose, { desc = "Close quickfix", buf = ev.buf })
end, { pattern = "qf", desc = "Set up quickfix keymaps" })

vim.keymap.set("n", "<leader>sm", vim.cmd.messages, { desc = "Messages" })
