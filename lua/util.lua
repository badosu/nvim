local M = {}

local gr = vim.api.nvim_create_augroup("custom-config", {})

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
