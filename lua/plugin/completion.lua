require("mini.snippets").setup()
require("mini.cmdline").setup()

require("mini.completion").setup({
  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false,
  },
})

-- Trigger LSP completion directly to prevent buffer text fallback
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
  end,
})

-- To use <Tab> and <S-Tab> for navigation through completion list, make these mappings:
local imap_expr = function(lhs, rhs)
  vim.keymap.set("i", lhs, rhs, { expr = true })
end
imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

-- To get more consistent behavior of <CR>
local cr_action = function()
  -- If there is selected item in popup, accept it with <C-y>
  if vim.fn.complete_info()["selected"] ~= -1 then
    return "\25"
  end
  -- Fall back to plain `<CR>`. You might want to customize according
  -- to other plugins. For example if 'mini.pairs' is set up, replace
  -- next line with `return MiniPairs.cr()`
  return "\r"
end

vim.keymap.set("i", "<CR>", cr_action, { expr = true })
