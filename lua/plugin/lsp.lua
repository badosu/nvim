vim.pack.add({
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/williamboman/mason-lspconfig.nvim",
  "https://github.com/neovim/nvim-lspconfig",
})

require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = Config.settings.tools })

vim.lsp.config("basedpyright", {
  before_init = function(_, new_config)
    if vim.fn.executable("uv") == 1 then
      new_config.cmd = vim.list_extend({ "uv", "run" }, new_config.cmd)
    end
  end,
})

Config.on("FileType", function()
  vim.pack.add({ "https://github.com/folke/lazydev.nvim" })

  require("lazydev").setup({
    library = {
      -- See the configuration section for more details
      -- Load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })
end, { pattern = "lua" })
