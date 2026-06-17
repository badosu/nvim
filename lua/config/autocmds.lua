local utils = require("utils")

utils.once("UIEnter", function()
  local chanid = vim.v.event["chan"]
  local chan = vim.api.nvim_get_chan_info(chanid)

  vim.opt.guifont = "IosevkaTerm Nerd Font Mono:h14"
  vim.opt.winblend = 0
  vim.opt.pumblend = 0

  if chan.client.name and vim.g.neovide then
    require("config.neovide")
  end
end, { desc = "Set up GUI config" })

-- Echo lsp_progress  ==========================================================
local lsp_progress = {}

local setup_lsp_progress = function(args)
  utils.on("LspProgress", function(ev)
    ---@type vim.event.lspprogress.data
    local data = ev.data
    local value = data.params.value
    local client = vim.lsp.get_client_by_id(data.client_id)
    if client == nil then
      return vim.notify("LSP Progress: client is nil", vim.log.levels.WARN)
    end

    -- Construct LSP progress id
    local lsp_progress_id = data.params.token
    local progress_info = lsp_progress[lsp_progress_id] or {}

    -- Store percentage to be used if no new one was sent
    progress_info.percentage = (value.kind == "end" and 100 or value.percentage) or progress_info.percentage or 0

    -- Cache title because it is only supplied on 'begin'
    progress_info.title = string.format(" 󱁤 %s", value.title)

    local msg = {
      { value.message or "done" },
      { string.format(" %s", client.name), "DiagnosticHint" },
      { string.format(" #%s", client.id), "DiagnosticInfo" },
    }

    vim.api.nvim_echo(msg, false, {
      id = "lsp." .. lsp_progress_id,
      kind = "progress",
      source = "vim.lsp",
      title = progress_info.title,
      status = value.kind ~= "end" and "running" or "success",
      percent = progress_info.percentage,
    })

    -- Cache progress info
    lsp_progress[lsp_progress_id] = progress_info

    -- Hide notification after last update to reduce flicker
    if value.kind == "end" then
      lsp_progress[lsp_progress_id] = nil
    end
  end, {
    buffer = args.buf,
    desc = "Notify LSP Progress",
  })
end

utils.on("LspAttach", setup_lsp_progress, { desc = "Set up LSP Progress" })

-- Auto-delete initial buffer when a real file is opened =======================

-- Whether buffer is empty, unnamed, and not modified
local function is_scratch_buffer(bufnr)
  return vim.fn.bufname(bufnr) == "" and vim.bo[bufnr].buftype == "" and not vim.bo[bufnr].modified
end

local function check_scratch_buffer()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if is_scratch_buffer(bufnr) then
      pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
    end
  end
end

utils.once("BufReadPre", check_scratch_buffer, { desc = "Remove scratch buffer once first buffer is read" })
