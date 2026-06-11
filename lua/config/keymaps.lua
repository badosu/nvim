vim.keymap.set("n", "<leader>db", function()
  vim.api.nvim_buf_delete(0, {})
end, { desc = "Delete current buffer" })
