vim.pack.add({
  "https://github.com/kevinhwang91/nvim-bqf",
  "https://github.com/yorickpeterse/nvim-pqf"
})

require("bqf").bootstrap() -- only because we are inside FileType pattern=qf event

local signs = require("config.settings").diagnostic_signs
require("pqf").setup({
  signs = {
    error = { text = signs[vim.diagnostic.severity.ERROR], hl = "DiagnosticSignError" },
    warning = { text = signs[vim.diagnostic.severity.WARN], hl = "DiagnosticSignWarn" },
    hint = { text = signs[vim.diagnostic.severity.HINT], hl = "DiagnosticSignHint" },
    info = { text = signs[vim.diagnostic.severity.INFO], hl = "DiagnosticSignInfo" },
  },
})
