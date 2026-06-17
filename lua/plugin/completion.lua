require("mini.snippets").setup()
require("mini.completion").setup({
  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false,
  },
})

-- Trigger LSP completion directly to prevent buffer text fallback
require("utils").once_lsp(function(ev)
  local bo = ev and vim.bo[ev.buf] or vim.bo
  bo.omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
end, { desc = "Set up LSP omnifunc" })
