vim.pack.add({
  -- "https://github.com/nvim-treesitter/nvim-treesitter",
  -- "https://github.com/nvim-mini/mini.nvim", -- if you use the mini.nvim suite
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
})

require("render-markdown").setup({
  completions = { lsp = { enabled = true } },
})
