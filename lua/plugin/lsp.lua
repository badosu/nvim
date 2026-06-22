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

-- local neovim_config_path = vim.fn.stdpath("config")
--
-- local function get_pack_paths()
--   local paths = {}
--   local pack_glob = string.format("%s/%s/*", vim.fn.stdpath("data"), "site/pack/core/opt")
--   for _, dir in ipairs(vim.fn.glob(pack_glob, true, true)) do
--     table.insert(paths, dir)
--   end
--
--   return paths
-- end
--
-- vim.lsp.config("lua_ls", {
--   settings = { Lua = { workspace = { library = { "$VIMRUNTIME" } } } },
--   ---@param client vim.lsp.Client
--   on_init = function(client)
--     local root = client.workspace_folders
--         and client.workspace_folders[1]
--         and vim.uri_to_fname(client.workspace_folders[1].uri)
--       or vim.fn.getcwd()
--
--     if not vim.startswith(root, neovim_config_path) then
--       return
--     end
--
--     local settings = client.config.settings.Lua
--     vim.list_extend(settings.workspace.library, get_pack_paths())
--   end,
-- })
