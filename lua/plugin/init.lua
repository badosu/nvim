Config.require_on("UIEnter", {
  "plugin.tokyonight",
  "plugin.mini",
  "plugin.lsp",
})

-- We use mise when under GUI due to lacking the env of a profile shell
Config.require_on("GUIEnter", { "plugin.mise" })
Config.require_on("BufReadPre", { "plugin.treesitter" })
Config.require_on("InsertEnter", { "plugin.completion", "plugin.conform" })

Config.require_on("User", {
  "plugin.neotest",
  "plugin.dap",
  "plugin.gitsigns",
  "plugin.neogit",
}, { pattern = "GitBufOpen" })

Config.require_on("FileType", "plugin.markdown", { pattern = "markdown" })
Config.require_on("FileType", "plugin.quick_fix", { pattern = "qf" })
