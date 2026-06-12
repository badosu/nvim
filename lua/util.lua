local M = {}

local gr = vim.api.nvim_create_augroup("custom-config", {})

M.is_dot_home_project = function(path)
  path = vim.fs.normalize(path)

  local home = vim.fs.normalize(vim.fn.expand("~"))

  if path:sub(1, #home) ~= home then
    return false
  end

  local rel = path:sub(#home + 2)

  for part in rel:gmatch("[^/]+") do
    if part:sub(1, 1) == "." then
      return true
    end
  end

  return false
end

M.once_on = function(ev, callback)
  vim.api.nvim_create_autocmd(ev, {
    group = gr,
    once = true,
    callback = callback,
  })
end

M.require_on = function(ev, paths)
  if type(paths) == "string" then
    paths = { paths }
  end

  vim.api.nvim_create_autocmd(ev, {
    group = gr,
    once = true,
    callback = function()
      for _, path in ipairs(paths) do
        require(path)
      end
    end,
  })
end

M.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end

return M
