require("plugin.mini")

local snippets = require("mini.snippets")
local gen_loader = snippets.gen_loader
snippets.setup({
  snippets = {
    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },
})

require("mini.completion").setup({
  lsp_completion = {
    source_func = "omnifunc",
    auto_setup = false,
  },
})

-- Trigger LSP completion directly to prevent buffer text fallback
Config.on("BufEnter", function(ev)
  local bo = ev and vim.bo[ev.buf] or vim.bo
  bo.omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
end, { desc = "Set up LSP omnifunc" })

-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function(args)
--     vim.bo[args.buf].complete = "" -- disable words completion
--   end,
-- })
