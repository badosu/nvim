vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

require("mini.input").setup()
require("mini.align").setup()
require("mini.surround").setup({})
require("mini.cmdline").setup()
require("mini.statusline").setup()
require("mini.misc").setup_auto_root()
require("mini.jump").setup()

local tabline = require("mini.tabline")
tabline.setup({
  format = function(buf_id, label)
    local title = vim.b[buf_id].term_title
    if title and title ~= "" then
      label = title
    end

    return tabline.default_format(buf_id, label)
  end,
})

local bufremove = require("mini.bufremove")

vim.keymap.set("n", "<leader>bd", function()
  bufremove.delete(vim.api.nvim_get_current_buf())
end, { desc = "Delete current buffer" })

local bracketed = require("mini.bracketed")
bracketed.setup()

vim.keymap.set("n", "H", Fn(bracketed.buffer, "backward"), { desc = "Cycle previous buffer" })
vim.keymap.set("n", "L", Fn(bracketed.buffer, "forward"), { desc = "Cycle next buffer" })

require("mini.basics").setup({
  -- Mappings. Set field to `false` to disable.
  mappings = {
    -- Basic mappings (better 'jk', save with Ctrl+S, ...)
    basic = false,
    -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
    -- Supply empty string to not create these mappings.
    option_toggle_prefix = [[\]],
    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    move_with_alt = true,
  },
  autocommands = {
    -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
    basic = true,
    -- Set 'relativenumber' only in linewise and blockwise Visual mode
    relnum_in_visual_mode = true,
  },
  -- Options. Set field to `false` to disable.
  options = {
    -- Basic options ('number', 'ignorecase', and many more)
    basic = false,
    -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
    extra_ui = false,
  },
})

-- mini.pick ===================================================================
local pick = require("mini.pick")
pick.setup({
  mappings = {
    choose_marked = "<C-q>", -- Send to quickfix or loclist
  },
})

vim.keymap.set("n", "<leader><leader>", pick.builtin.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sb", pick.builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sh", pick.builtin.help, { desc = "Help" })
vim.keymap.set("n", "<leader>sh", pick.builtin.help, { desc = "Help" })

local open_config_picker = Fn(pick.builtin.files, nil, { source = { cwd = vim.fn.stdpath("config") } })
vim.keymap.set("n", "<leader>sc", open_config_picker, { desc = "Edit config" })

-- mini.extra ==

local extra = require("mini.extra")
extra.setup()

local pick_symbols_doc = Fn(extra.pickers.lsp, { scope = "document_symbol" })
vim.keymap.set("n", "<leader>sl", pick_symbols_doc, { desc = "Document Symbol (LSP)" })
local pick_symbols_ws = Fn(extra.pickers.lsp, { scope = "workspace_symbol" })
vim.keymap.set("n", "<leader>sL", pick_symbols_ws, { desc = "Workspace Symbol (LSP)" })

-- mini.clue ===================================================================
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { "n", "x" }, keys = "<Leader>" },
    { mode = "n", keys = "\\" },
    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },
    -- Marks
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },
    -- Registers
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },

    { mode = "i", keys = "<C-x>" }, -- Built-in completion
    { mode = { "n", "x" }, keys = "g" }, -- `g` key
    { mode = "n", keys = "<C-w>" }, -- Window commands
    { mode = { "n", "x" }, keys = "z" }, -- `z` key
    { mode = { "v", "n" }, keys = "s" }, -- mini.surround
  },

  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    Config.settings.clues,
  },

  window = {
    delay = 0,
    config = { anchor = "SE", width = "auto", row = "auto", col = "auto" },
  },
})

-- movement for treesitter objects, e.g. cif (delete inner function) ===========
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" } })

local ai = require("mini.ai")
ai.setup({
  n_lines = 500,
  mappings = {
    -- Next/last variants
    -- NOTE: This (deliberately) overrides Neovim>=0.12 built-in incremental
    -- selection mappings. See `:h MiniAi-default-an-in` for more details.
    around_next = "aN",
    inside_next = "iN",
    around_last = "aL",
    inside_last = "iL",
  },
  custom_textobjects = {
    -- Function calls
    u = ai.gen_spec.function_call(),

    -- Arguments
    a = ai.gen_spec.argument(),

    -- Functions
    f = ai.gen_spec.treesitter({
      a = "@function.outer",
      i = "@function.inner",
    }),

    -- Classes
    c = ai.gen_spec.treesitter({
      a = "@class.outer",
      i = "@class.inner",
    }),

    -- Blocks / loops / conditionals
    o = ai.gen_spec.treesitter({
      a = {
        "@block.outer",
        "@conditional.outer",
        "@loop.outer",
      },
      i = {
        "@block.inner",
        "@conditional.inner",
        "@loop.inner",
      },
    }),
  },
})

-- mini.files ==================================================================
local files = require("mini.files")
files.setup({
  mappings = {
    go_in = "L",
    go_in_plus = "l",
    go_out = "H",
    go_out_plus = "h",
  },
})

-- Fresh explorer in directory of current file
vim.keymap.set("n", "-", function()
  local path = vim.api.nvim_buf_get_name(0)

  -- do nothing if buffer is not empty and is not associated to a file path
  if path ~= "" and vim.bo.buftype ~= "" then
    return
  end

  files.open(path, false)
end, { desc = "Explore buffer directory" })

-- Fresh explorer in current working directory
vim.keymap.set("n", "<C-->", Fn(files.open, nil, false), { desc = "Explore CWD" })

local show_dotfiles = true

---@diagnostic disable-next-line: unused-local
local filter_show = function(fs_entry)
  return true
end

local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

Config.on("User", function(args)
  local go_in = Fn(files.go_in, { close_on_file = true })
  vim.keymap.set("n", "<enter>", go_in, { buffer = args.data.buf_id, desc = "Go in" })
  vim.keymap.set("n", "-", files.go_out, { buffer = args.data.buf_id, desc = "Go out" })
  vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = args.data.buf_id, desc = "Toggle show dotfiles" })
  vim.keymap.set("n", "<C-[>", files.close, { buffer = args.data.buf_id, desc = "Close" })
end, {
  pattern = "MiniFilesBufferCreate",
  desc = "Set up keymaps for mini.files",
})

-- mini.hipatterns =============================================================
local mini_patterns = require("mini.hipatterns")

local hi_todo = function(words, hl_name)
  -- Examples: `NOTE` `NOTE:` ` NOTE ` ` NOTE:`
  -- WARN: asdasdasdasd
  local pattern = vim
    .iter(words)
    :map(function(word)
      return { "%f[%w]()" .. word .. "()%f[%W]", "() " .. word .. "[: ]()" }
    end)
    :flatten()
    :totable()

  return {
    pattern = pattern,
    -- NOTE: Highlight only inside treesitter comments when a parser is available
    group = function(buf, _, data)
      local parser = vim.treesitter.get_parser(buf, nil, { error = false })
      if not parser then
        return hl_name
      end
      local range4 = {
        data.line - 1,
        data.from_col - 1,
        data.line - 1,
        data.to_col - 1,
      }
      parser:parse(range4)
      local node = parser:named_node_for_range(range4)
      if node and node:type() == "comment_content" then
        return hl_name
      end
    end,
  }
end

mini_patterns.setup({
  highlighters = {
    fix = hi_todo({ "FIX", "FIXME" }, "MiniHipatternsFixme"),
    note = hi_todo({ "NOTE" }, "MiniHipatternsNote"),
    todo = hi_todo({ "TODO", "FEAT" }, "MiniHipatternsTodo"),
    hack = hi_todo({ "HACK", "WARN", "WARNING" }, "MiniHipatternsHack"),
  },
})

-- custom project picker =====================================================
local project = require("config.project")

project.setup({
  event = "User",
  event_opts = { pattern = "GitBufOpen" },
  detect = function(path, data)
    return not Config.is_dot_home_project(path) and (data.git_root or vim.fs.root(path, { ".git" }))
  end,
})

vim.keymap.set("n", "<leader>sp", project.pick, { desc = "Projects" })

-- mini.starter ================================================================
local starter = require("mini.starter")

local recent_projects = function(length)
  local items = {}

  for i, entry in ipairs(project.list(length)) do
    table.insert(items, {
      name = string.format("%i %s", i, entry.text),
      section = "Recent Projects",
      action = Fn(project.choose, entry),
    })
  end

  return items
end

-- local get_fortune = function()
--   local size = 200
--   local cmd = string.format("fortune -n %d -s 2>/dev/null", size)
--   local handle = io.popen(cmd)
--
--   if not handle then
--     return
--   end
--
--   local fortune = handle:read("*a"):gsub("%s+$", "") -- Read output and trim whitespace
--   handle:close()
--
--   return fortune
-- end

local open_notes = function()
  local note_dir = "~/Documents/notes"

  vim.fn.chdir(note_dir)
  pick.builtin.files(nil, { source = { cwd = note_dir } })
end

local starter_items = {
  { name = "Manage Notes", action = open_notes, section = "Actions" },
  { name = "Project Open", action = project.pick, section = "Actions" },
  { name = "Config Edit", action = open_config_picker, section = "Actions" },
  { name = "Explore", action = files_cwd, section = "Actions" },
  { name = "New Buffer", action = "enew", section = "Actions" },
  { name = "Update Plugins", action = vim.pack.update, section = "Actions" },
  { name = "Quit Neovim", action = "qall", section = "Actions" },
  recent_projects(5),
}

starter.setup({
  autoopen = false,
  evaluate_single = true, -- trigger as soon as query is resolved
  items = starter_items,
  footer = "",
})

-- NOTE: We already passed VimEnter so we need to open manually, but we need to
-- avoid opening when a file was opened from cmdline
if vim.fn.argc() == 0 and vim.fn.line2byte(1) == -1 and vim.bo.buftype == "" then
  starter.open()
end

-- mini.icons ===================================================================

local icons = require("mini.icons")

icons.setup({ lsp = Config.settings.icons.lsp })
icons.mock_nvim_web_devicons()
Config.once_lsp(function()
  icons.tweak_lsp_kind()
end, { desc = "Tweak LSP kinds for mini.icons once" })

-- mini.notify =================================================================
local notify = require("mini.notify")
notify.setup({
  content = {
    format = function(notif)
      return notif.msg
    end,
  },
  lsp_progress = {
    -- Whether to enable showing
    enable = false,
  },
})

vim.keymap.set("n", "<leader>sn", notify.show_history, { desc = "Notifications" })

-- completion ===================================
local snippets = require("mini.snippets")
local gen_loader = snippets.gen_loader
snippets.setup({
  snippets = {
    -- Load snippets based on current language by reading files from
    -- "snippets/" subdirectories from 'runtimepath' directories.
    gen_loader.from_lang(),
  },
})

require("mini.completion").setup({
  fallback_action = "", -- avoid ^N insertion by mini.completion when complete is empty
})
