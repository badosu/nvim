Config.once("BufEnter", Fn(vim.cmd.packadd, "nvim.undotree"), { desc = "Set up undotree" })

Config.require_on("UIEnter", {
  "plugin.colorscheme",
  "plugin.mini",
  "plugin.lsp",
})

-- We use mise when under GUI due to lacking the env of a profile shell
Config.require_on("GUIEnter", { "plugin.mise" })
Config.require_on("BufReadPre", { "plugin.treesitter", "plugin.lint" })

Config.require_on("User", {
  "plugin.neotest",
  "plugin.dap",
  "plugin.gitsigns",
  "plugin.neogit",
}, { pattern = "GitBufOpen" })

Config.require_on("FileType", "plugin.markdown", { pattern = "markdown" })
Config.require_on("FileType", "plugin.quickfix", { pattern = "qf" })
