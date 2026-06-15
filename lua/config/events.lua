local check_git_repo = function(arg)
  local file = vim.api.nvim_buf_get_name(arg.buf)
  if file == "" then
    return
  end

  local root = vim.fs.root(file, ".git")
  if not root then
    return
  end

  vim.api.nvim_exec_autocmds("User", {
    pattern = "GitBufOpen",
    data = vim.tbl_extend("keep", { git_root = root }, arg),
  })
end

require("util").new_autocmd(
  { "BufReadPost", "BufNewFile" },
  check_git_repo,
  { desc = "Check if this file is inside a git tracked repository" }
)
