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

vim.keymap.set("n", "<leader>tt", function()
  neotest.run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>td", function()
  ---@diagnostic disable-next-line: missing-fields
  neotest.run.run({ strategy = "dap" })
end, { desc = "Run nearest test (debug)" })

vim.keymap.set("n", "<leader>tr", function()
  neotest.run.run_last()
end, { desc = "Run last test" })

vim.keymap.set("n", "<leader>ts", function()
  neotest.run.stop()
end, { desc = "Stop test run" })

vim.keymap.set("n", "<leader>tf", function()
  neotest.run.run(vim.fn.expand("%"))
end, { desc = "Run file tests" })

vim.keymap.set("n", "<leader>to", function()
  neotest.output_panel.toggle()
end, { desc = "Toggle output panel" })

vim.keymap.set("n", "<leader>ts", function()
  neotest.summary.toggle()
end, { desc = "Toggle summary panel" })
