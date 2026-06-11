local M = {}

-- --------------------------------------------------------------------------
-- Highlights (theme-agnostic, with safe fallbacks)
-- --------------------------------------------------------------------------

local function hl(name, link, fallback)
  if vim.fn.hlexists(link) == 1 then
    vim.api.nvim_set_hl(0, name, { link = link })
  elseif fallback then
    vim.api.nvim_set_hl(0, name, { link = fallback })
  end
end

local function setup_highlights()
  -- Mode highlights (prefer mini.statusline if available)
  hl("SLModeNormal", "MiniStatuslineModeNormal", "Statement")
  hl("SLModeInsert", "MiniStatuslineModeInsert", "String")
  hl("SLModeVisual", "MiniStatuslineModeVisual", "Type")
  hl("SLModeReplace", "MiniStatuslineModeReplace", "ErrorMsg")
  hl("SLModeCommand", "MiniStatuslineModeCommand", "Constant")

  -- File / git / misc
  hl("SLFile", "StatusLine")
  hl("SLGit", "Directory")
  hl("SLModified", "DiagnosticOk", "DiffAdd")

  -- Diagnostics (standard Neovim groups)
  hl("SLDiagError", "DiagnosticError")
  hl("SLDiagWarn", "DiagnosticWarn")
  hl("SLDiagInfo", "DiagnosticInfo")
  hl("SLDiagHint", "DiagnosticHint")
end

setup_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_highlights,
})

-- --------------------------------------------------------------------------
-- Mode
-- --------------------------------------------------------------------------

local modes = {
  n = { "", "SLModeNormal" }, -- normal / default state (Neovim logo style)
  i = { "", "SLModeInsert" }, -- “typing / input”
  v = { "󰈈", "SLModeVisual" }, -- selection (keep this, it's already good)
  V = { "󰈉", "SLModeVisual" },
  ["\22"] = { "󰘶", "SLModeVisual" },
  R = { "󰛔", "SLModeReplace" }, -- overwrite feel is good already
  c = { "", "SLModeCommand" }, -- command prompt arrow is clearer than generic glyph
  t = { "", "SLModeInsert" }, -- terminal is fine
}

local function mode_component()
  local data = modes[vim.fn.mode()] or { "?", "SLModeNormal" }
  return string.format("%%#%s# %s %%*", data[2], data[1])
end

-- --------------------------------------------------------------------------
-- File
-- --------------------------------------------------------------------------

local cached_file_info = ""

local function update_file_info()
  local filename = vim.fn.expand("%:t")

  if filename == "" then
    cached_file_info = "󰈔 [No Name]"
    return
  end

  local ok, mini_icons = pcall(require, "mini.icons")
  local icon = ok and (mini_icons.get("file", filename) or "󰈔") or "󰈔"

  local modified = vim.bo.modified and " %#SLModified#●%*" or ""

  cached_file_info = string.format("%%#SLFile#%s %s%%*%s", icon, filename, modified)
end

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufFilePost",
  "BufModifiedSet",
}, {
  callback = update_file_info,
})

-- initialize
update_file_info()

-- --------------------------------------------------------------------------
-- Git
-- --------------------------------------------------------------------------

local function git_branch()
  local head = vim.b.gitsigns_head
  if not head or head == "" then
    return ""
  end

  return string.format("%%#SLGit# %s%%*", head)
end

-- --------------------------------------------------------------------------
-- Diagnostics
-- --------------------------------------------------------------------------

local diag_icons = {
  Error = "󰅚",
  Warn = "󰀪",
  Info = "󰋽",
  Hint = "󰌶",
}

local function diagnostics()
  local severities = {
    Error = vim.diagnostic.severity.ERROR,
    Warn = vim.diagnostic.severity.WARN,
    Info = vim.diagnostic.severity.INFO,
    Hint = vim.diagnostic.severity.HINT,
  }

  local parts = {}

  for name, severity in pairs(severities) do
    local count = #vim.diagnostic.get(0, {
      severity = severity,
    })

    if count > 0 then
      table.insert(parts, string.format("%%#SLDiag%s#%s %d%%*", name, diag_icons[name], count))
    end
  end

  return table.concat(parts, " ")
end

-- --------------------------------------------------------------------------
-- Statusline
-- --------------------------------------------------------------------------

function M.statusline()
  local left = table.concat(
    vim.tbl_filter(function(x)
      return x ~= ""
    end, {
      mode_component(),
      cached_file_info,
      git_branch(),
    }),
    " "
  )

  local right = table.concat(
    vim.tbl_filter(function(x)
      return x ~= ""
    end, {
      diagnostics(),
      "%p%%",
      "%l:%c",
    }),
    "  "
  )

  return left .. "%=" .. right
end

vim.o.statusline = "%!v:lua.require'config.statusline'.statusline()"

return M
