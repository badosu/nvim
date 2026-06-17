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

local gui_enter = function(ev)
  local chanid = vim.v.event["chan"]
  local chan = vim.api.nvim_get_chan_info(chanid)
  local client = chan.client

  -- WARN: This probably won't work well when operating as server/client
  if client and client.type == "ui" and client.name ~= "nvim-tui" then
    vim.api.nvim_exec_autocmds("GUIEnter", { data = { chan = chan } })
    vim.api.nvim_del_autocmd(ev.id)
  end
end

Config.on("BufEnter", check_git_repo, { desc = "Dispatch GitBufOpen" })
Config.once("UIEnter", gui_enter, { desc = "Dispatch GUIEnter" })
