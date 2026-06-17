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

local utils = require("utils")

utils.on("BufEnter", function(ev)
  check_git_repo(ev)

  if utils.buf_is_quickfix(ev.buf) then
    vim.api.nvim_exec_autocmds("User", { pattern = "QfBufOpen" })
  end
end, { desc = "Check for GitBufOpen and QfBufOpen triggers" })
