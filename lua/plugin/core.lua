-- native :Undotree
vim.cmd("packadd nvim.undotree")

-- mini.surround
vim.pack.add({ "https://github.com/nvim-mini/mini.surround" })
require("mini.surround").setup({})

-- movement for treesitter objects, e.g. cif (delete inner function)
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  { src = "https://github.com/nvim-mini/mini.ai" },
})

local ai = require("mini.ai")

ai.setup({
  n_lines = 500,

  custom_textobjects = {
    -- Functions
    f = ai.gen_spec.treesitter({
      a = "@function.outer",
      i = "@function.inner",
    }),

    -- Classes
    c = ai.gen_spec.treesitter({
      a = "@class.outer",
      i = "@class.inner",
    }),

    -- Blocks / loops / conditionals
    o = ai.gen_spec.treesitter({
      a = {
        "@block.outer",
        "@conditional.outer",
        "@loop.outer",
      },
      i = {
        "@block.inner",
        "@conditional.inner",
        "@loop.inner",
      },
    }),

    -- Function calls
    u = ai.gen_spec.function_call(),

    -- Arguments
    a = ai.gen_spec.argument(),
  },
})
