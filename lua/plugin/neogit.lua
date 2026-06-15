vim.pack.add({
  { src = "https://github.com/NeogitOrg/neogit" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/m00qek/baleia.nvim" },
})

local neogit = require("neogit")

vim.keymap.set("n", "<leader>hh", function()
  if neogit.status and neogit.status.is_open() then
    neogit.close()
  else
    neogit.open()
  end
end, { desc = "Toggle Neogit" })
