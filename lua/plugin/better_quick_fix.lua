vim.pack.add({ "https://github.com/kevinhwang91/nvim-bqf", "https://github.com/yorickpeterse/nvim-pqf" })

require("pqf").setup({
  signs = {
    error = { text = "", hl = "DiagnosticSignError" },
    warning = { text = "", hl = "DiagnosticSignWarn" },
    hint = { text = "", hl = "DiagnosticSignHint" },
    info = { text = "", hl = "DiagnosticSignInfo" },
  },
})
