vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/jfpedroza/neotest-elixir" },
  { src = "https://github.com/nvim-neotest/neotest-python" },
})

local neotest = require("neotest")
---@diagnostic disable-next-line: missing-fields
neotest.setup({
  adapters = {
    require("neotest-elixir"),
    require("neotest-python"),
  },
})

vim.keymap.set("n", "<leader>tt", neotest.run.run, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tr", neotest.run.run_last, { desc = "Run last test" })
vim.keymap.set("n", "<leader>ts", neotest.run.stop, { desc = "Stop test run" })
vim.keymap.set("n", "<leader>to", neotest.output_panel.toggle, { desc = "Toggle output panel" })
vim.keymap.set("n", "<leader>ts", neotest.summary.toggle, { desc = "Toggle summary panel" })

vim.keymap.set("n", "<leader>td", Fn(neotest.run.run, { strategy = "dap" }), { desc = "Run nearest test (debug)" })

vim.keymap.set("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })
