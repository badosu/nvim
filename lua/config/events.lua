local check_git_repo = function(ev)
  local file = vim.api.nvim_buf_get_name(ev.buf)
  if file == "" then
    return
  end

  local root = vim.fs.root(file, ".git")
  if not root then
    return
  end

  vim.api.nvim_exec_autocmds("User", {
    pattern = "GitBufOpen",
    data = vim.tbl_extend("keep", { git_root = root }, ev),
  })
end

-- Dispatches GUIEnter when a non TUI client connects. Assume a single local ui
-- to connect.
--
-- WARN: This probably won't work well when operating as server/client.
local gui_enter = function(ev)
  local chanid = vim.v.event["chan"]
  if not chanid then
    return vim.notify("GUIEnter: event[chan] is nil", vim.log.levels.WARN)
  end

  local chan = vim.api.nvim_get_chan_info(chanid)
  local client = chan.client

  if not client then
    return vim.notify("GUIEnter: client is nil", vim.log.levels.WARN)
  end

  if client.type ~= "ui" or client.name == "nvim-tui" then
    return
  end

  vim.api.nvim_exec_autocmds("GUIEnter", { data = { chan = chan } })
  vim.api.nvim_del_autocmd(ev.id)
end

Config.on("BufEnter", check_git_repo, { desc = "Dispatch GitBufOpen" })
Config.once("UIEnter", gui_enter, { desc = "Dispatch GUIEnter" })
