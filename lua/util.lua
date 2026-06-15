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

local autocmd_opts = { group = gr }

M.new_autocmd = function(ev, callback, opts)
  opts = vim.tbl_extend("keep", autocmd_opts, {
    callback = callback,
  }, opts or {})

  vim.api.nvim_create_autocmd(ev, opts)
end

M.once_on = function(ev, callback, opts)
  M.new_autocmd(ev, callback, vim.tbl_extend("keep", { once = true }, opts or {}))
end

M.require_on = function(ev, paths, opts)
  if type(paths) == "string" then
    paths = { paths }
  end

  opts = vim.tbl_extend("keep", { desc = "Lua require: " .. table.concat(paths, " | ") }, opts or {})

  M.once_on(ev, function()
    for _, path in ipairs(paths) do
      require(path)
    end
  end, opts)
end

return M
