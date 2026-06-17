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

Config.on("BufEnter", function(ev)
  check_git_repo(ev)
end, { desc = "Dispatch GitBufOpen" })

Config.once("UIEnter", function()
  local chanid = vim.v.event["chan"]
  local chan = vim.api.nvim_get_chan_info(chanid)
  local client = chan.client

  if client.type == "ui" and client.name ~= "nvim-tui" then
    vim.api.nvim_exec_autocmds("GUIEnter", { data = { chan = chan } })
  end
end, { desc = "Dispatch GUIEnter" })
