local utils = require("utils")

local lsp_progress = {}

utils.new_autocmd("LspAttach", function(args)
  utils.new_autocmd("LspProgress", function(ev)
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
end, { desc = "Set up LSP progress" })
