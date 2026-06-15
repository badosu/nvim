local pick = require("mini.pick")

local M = {}

local config = {
  event = { "BufReadPost", "BufNewFile" },
  event_opts = {
    group = vim.api.nvim_create_augroup("pick.project", {}),
    desc = "Check if this file belongs to a project to be added",
  },
  detect = function(path, _)
    return vim.fs.root(path, ".git")
  end,
  state_file = vim.fs.joinpath(vim.fn.stdpath("state"), "projects.json"),
}

local projects = {}
local dirty = false
local save_pending = false

local function mark_dirty()
  dirty = true

  if save_pending then
    return
  end

  save_pending = true

  vim.defer_fn(function()
    save_pending = false
    if not dirty then
      return
    end

    dirty = false

    vim.fn.mkdir(vim.fn.fnamemodify(config.state_file, ":h"), "p")
    vim.fn.writefile({ vim.json.encode(projects) }, config.state_file)
  end, 2000)
end

local function load()
  local ok, decoded = pcall(vim.json.decode, vim.fn.readblob(config.state_file))

  if ok and type(decoded) == "table" then
    projects = decoded
  end
end

local function cleanup()
  local changed = false

  for path in pairs(projects) do
    if not config.detect(path, {}) then
      projects[path] = nil
      changed = true
    end
  end

  if changed then
    mark_dirty()
  end
end

local function add(path)
  path = vim.fs.normalize(path)

  if not projects[path] then
    projects[path] = {
      path = path,
      name = vim.fs.basename(path),
    }
  end

  projects[path].last_used = 0

  mark_dirty()
end

---@return boolean touched whether a project was present to be touched
local function touch(path)
  local project = projects[path]
  if not project then
    return false
  end

  project.last_used = os.time()
  mark_dirty()

  return true
end

local function display_name(path)
  local home = vim.fn.expand("~")
  path = vim.fs.normalize(path)

  -- 1. replace home with ~
  if path:sub(1, #home) == home then
    path = "~" .. path:sub(#home + 1)
  end

  path = path:gsub("^/", "")

  return path
end

function M.list(length)
  length = length or -1

  local items = vim.tbl_values(projects)

  table.sort(items, function(a, b)
    return (a.last_used or 0) > (b.last_used or 0)
  end)

  if length > 0 then
    items = vim.list_slice(items, 1, length)
  end

  return vim.tbl_map(function(p)
    return {
      path = p.path,
      text = display_name(p.path),
      last_used = p.last_used,
    }
  end, items)
end

local function check_buffer(arg)
  local file = vim.api.nvim_buf_get_name(arg.buf or arg.data.buf)
  if file == "" then
    return
  end

  local root = config.detect(file, { data = arg.data })

  if root and not touch(root) then
    add(root)
  end
end

-- ```lua
-- require("config.project").setup({
--   event = { "BufReadPost", "BufNewFile" },
--   detect = function(path)
--     return vim.fs.root(path, ".git")
--   end,
--   state_file = vim.fs.joinpath(vim.fn.stdpath("state"), "projects.json")
-- })
-- ```
function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  load()
  cleanup()

  -- So that we can check buffers opened via cmdline (does not trigger bufreadpost, bufnewfile)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    check_buffer({ buf = buf })
  end

  local event_opts = vim.tbl_deep_extend("keep", { callback = check_buffer }, config.event_opts or {})
  vim.api.nvim_create_autocmd(config.event, event_opts)
end

function M.choose(item)
  if not item then
    return
  end

  touch(item.path)
  vim.fn.chdir(item.path)
  vim.schedule(function()
    pick.builtin.files(nil, { source = { cwd = item.path } })
  end)
end

local preview = function(buf_id, item)
  if not item then
    return
  end

  local files = {}

  for name, typ in vim.fs.dir(item.path) do
    if typ == "file" and not name:match("^%.") then
      table.insert(files, name)
    end
  end

  table.sort(files)

  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, files)
end

function M.pick(opts)
  local source = {
    name = "Projects",
    items = M.list(-1),
    choose = M.choose,
    preview = preview,
  }

  opts = vim.tbl_deep_extend("force", {
    source = source,
  }, opts or {})

  return pick.start(opts)
end

function M.add(path)
  path = vim.fs.normalize(path)

  if not projects[path] then
    projects[path] = {
      path = path,
      name = vim.fs.basename(path),
      last_used = os.time(),
    }
    mark_dirty()
  end
end

return M
