-- stylua: ignore start

local diagnostic_signs = {
  [vim.diagnostic.severity.ERROR] = "",
  [vim.diagnostic.severity.WARN] = "",
  [vim.diagnostic.severity.HINT] = "",
  [vim.diagnostic.severity.INFO] = "",
}

return {
  diagnostic_signs = diagnostic_signs,
  diagnostic = {
    signs = { text = diagnostic_signs },
    underline = { severity = { min = "HINT", max = "ERROR" } },
    virtual_lines = {
      current_line = true,
      severity = { min = "ERROR", max = "ERROR" },
    },
  },
  tools = {
    "lua_ls",
    "stylua",
    "jsonls",
    "dexter",
    "basedpyright",
  },
  icons = {
    lsp = {
      -- lazyvim kind icons
      array         = { glyph = "", hl = "MiniIconsOrange" },
      boolean       = { glyph = "󰨙", hl = "MiniIconsOrange" },
      enummember    = { glyph = "", hl = "MiniIconsYellow" },
      key           = { glyph = "", hl = "MiniIconsYellow" },
      namespace     = { glyph = "󰦮", hl = "MiniIconsRed" },
      null          = { glyph = "", hl = "MiniIconsGrey" },
      number        = { glyph = "󰎠", hl = "MiniIconsOrange" },
      object        = { glyph = "", hl = "MiniIconsGrey" },
      package       = { glyph = "", hl = "MiniIconsPurple" },
      string        = { glyph = "", hl = "MiniIconsGreen" },
      typeparameter = { glyph = "", hl = "MiniIconsCyan" },

      -- lazyvim lsp icons
      class         = { glyph = "󱡠", hl = "MiniIconsPurple" },
      color         = { glyph = "󰏘", hl = "MiniIconsRed" },
      constant      = { glyph = "󰏿", hl = "MiniIconsOrange" },
      constructor   = { glyph = "󰒓", hl = "MiniIconsAzure" },
      enum          = { glyph = "󰦨", hl = "MiniIconsPurple" },
      event         = { glyph = "󱐋", hl = "MiniIconsRed" },
      field         = { glyph = "󰜢", hl = "MiniIconsYellow" },
      file          = { glyph = "󰈔", hl = "MiniIconsBlue" },
      ["function"]  = { glyph = "󰊕", hl = "MiniIconsAzure" },
      folder        = { glyph = "󰉋", hl = "MiniIconsBlue" },
      interface     = { glyph = "󱡠", hl = "MiniIconsPurple" },
      keyword       = { glyph = "󰻾", hl = "MiniIconsCyan" },
      method        = { glyph = "󰊕", hl = "MiniIconsAzure" },
      module        = { glyph = "󰅩", hl = "MiniIconsPurple" },
      operator      = { glyph = "󰪚", hl = "MiniIconsCyan" },
      property      = { glyph = "󰖷", hl = "MiniIconsYellow" },
      reference     = { glyph = "󰬲", hl = "MiniIconsCyan" },
      snippet       = { glyph = "󱄽", hl = "MiniIconsGreen" },
      struct        = { glyph = "󱡠", hl = "MiniIconsPurple" },
      text          = { glyph = "󰉿", hl = "MiniIconsGreen" },
      unit          = { glyph = "󰪚", hl = "MiniIconsCyan" },
      value         = { glyph = "󰦨", hl = "MiniIconsBlue" },
      variable      = { glyph = "󰆦", hl = "MiniIconsCyan" },
    },
    dap = {
      Stopped             = { "󰁕", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = "",
      BreakpointCondition = "",
      BreakpointRejected  = { "", "DiagnosticError" },
      LogPoint            = ">",
    },
  },
  -- maps groups of keybindings (in mini.clues format)
  clues = {
    { mode = "n", keys = "<leader>x", desc = "+Diagnostic" },
    { mode = "n", keys = "<leader>s", desc = "+Search/Find" },
    { mode = "n", keys = "<leader>t", desc = "+Test" },
    { mode = "n", keys = "<leader>d", desc = "+Debug" },
    { mode = "n", keys = "<leader>h", desc = "+Git" },
    { mode = "n", keys = "<leader>b", desc = "+Buffer" },
    -- { mode = "n", keys = "<tab>", desc = "+Tab" }, -- doesnt work for some reason
  }
}
