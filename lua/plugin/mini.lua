local utils = require("utils")

require("mini.align").setup()
require("mini.surround").setup({})
require("mini.tabline").setup()
require("mini.cmdline").setup()
require("mini.statusline").setup()
require("mini.misc").setup_auto_root()

local bufremove = require("mini.bufremove")

vim.keymap.set("n", "<leader>bd", function()
  bufremove.delete(vim.api.nvim_get_current_buf())
end, { desc = "Delete current buffer" })

local bracketed = require("mini.bracketed")
bracketed.setup()

vim.keymap.set("n", "H", function()
  bracketed.buffer("backward")
end, { desc = "Cycle previous buffer" })

vim.keymap.set("n", "L", function()
  bracketed.buffer("forward")
end, { desc = "Cycle next buffer" })

require("mini.basics").setup({
  -- Options. Set field to `false` to disable.
  options = {
    -- Basic options ('number', 'ignorecase', and many more)
    basic = true,

    -- Extra UI features ('winblend', 'listchars', 'pumheight', ...)
    extra_ui = true,

    -- Presets for window borders ('single', 'double', ...)
    -- Default 'auto' infers from 'winborder' option
    win_borders = "auto",
  },

  -- Mappings. Set field to `false` to disable.
  mappings = {
    -- Basic mappings (better 'jk', save with Ctrl+S, ...)
    basic = false,

    -- Prefix for mappings that toggle common options ('wrap', 'spell', ...).
    -- Supply empty string to not create these mappings.
    option_toggle_prefix = [[\]],

    -- Window navigation with <C-hjkl>, resize with <C-arrow>
    windows = false,

    -- Move cursor in Insert, Command, and Terminal mode with <M-hjkl>
    move_with_alt = false,
  },

  -- Autocommands. Set field to `false` to disable
  autocommands = {
    -- Basic autocommands (highlight on yank, start Insert in terminal, ...)
    basic = true,

    -- Set 'relativenumber' only in linewise and blockwise Visual mode
    relnum_in_visual_mode = true,
  },
})

-- mini.pick ===================================================================
local pick = require("mini.pick")
pick.setup()

vim.keymap.set("n", "<leader><leader>", pick.builtin.files, { desc = "Find files" })
vim.keymap.set("n", "<leader>sg", pick.builtin.grep_live, { desc = "Live grep" })
vim.keymap.set("n", "<leader>sG", function()
  pick.builtin.grep_live({ tool = "rg --hidden" })
end, { desc = "Live grep (hidden files)" })
vim.keymap.set("n", "<leader>sb", pick.builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>sh", pick.builtin.help, { desc = "Help" })

local open_config_picker = function()
  local config_path = vim.fn.stdpath("config")
  pick.builtin.files(nil, { source = { cwd = config_path } })
end
vim.keymap.set("n", "<leader>sc", open_config_picker, { desc = "Edit config" })

-- mini.clue ===================================================================
local miniclue = require("mini.clue")
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = { "n", "x" }, keys = "<Leader>" },
    { mode = "n", keys = "\\" },

    { mode = { "v", "n" }, keys = "s" },

    -- `[` and `]` keys
    { mode = "n", keys = "[" },
    { mode = "n", keys = "]" },

    -- Built-in completion
    { mode = "i", keys = "<C-x>" },

    -- `g` key
    { mode = { "n", "x" }, keys = "g" },

    -- Marks
    { mode = { "n", "x" }, keys = "'" },
    { mode = { "n", "x" }, keys = "`" },

    -- Registers
    { mode = { "n", "x" }, keys = '"' },
    { mode = { "i", "c" }, keys = "<C-r>" },

    -- Window commands
    { mode = "n", keys = "<C-w>" },

    -- `z` key
    { mode = { "n", "x" }, keys = "z" },
  },

  clues = {
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    { mode = "n", keys = "<leader>x", desc = "+Diagnostic" },
    { mode = "n", keys = "<leader>s", desc = "+Search/Find" },
    { mode = "n", keys = "<leader>t", desc = "+Test" },
    { mode = "n", keys = "<leader>d", desc = "+Debug" },
    { mode = { "n", "h" }, keys = "<leader>h", desc = "+Git" },
    { mode = "n", keys = "<leader>b", desc = "+Buffer" },
    -- { mode = "n", keys = "<C-tab>", desc = "+Tab" }, -- doesnt work for some reason
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

  -- do nothing if buffer is not empty and is not associated to a real file
  if path ~= "" and vim.fn.filereadable(path) ~= 1 then
    return
  end

  files.open(path, false)
end, { desc = "Explore buffer directory" })

local files_cwd = function()
  files.open(nil, false)
end
-- Fresh explorer in current working directory
vim.keymap.set("n", "<C-->", files_cwd, { desc = "Explore CWD" })

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

utils.on("User", function(args)
  vim.keymap.set("n", "<enter>", function()
    files.go_in({ close_on_file = true })
  end, { buffer = args.data.buf_id, desc = "Go in" })
  vim.keymap.set("n", "-", files.go_out, { buffer = args.data.buf_id, desc = "Go out" })
  vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = args.data.buf_id, desc = "Toggle show dotfiles" })
  vim.keymap.set("n", "<C-[>", files.close, { buffer = args.data.buf_id, desc = "Close" })
end, {
  pattern = "MiniFilesBufferCreate",
  desc = "Set up keymaps for MiniFiles",
})

-- mini.hipatterns =============================================================
local mini_patterns = require("mini.hipatterns")

local update_mini_hl = function()
  local identifier_hl = vim.api.nvim_get_hl(0, { name = "Identifier", link = false })

  vim.api.nvim_set_hl(0, "UserHipatternsPerf", { bold = true, fg = "black", bg = identifier_hl.fg })
end

update_mini_hl()

utils.on("ColorScheme", update_mini_hl, {
  group = vim.api.nvim_create_augroup("todo_highlight", { clear = true }),
  desc = "Update todo_highlight user highlights",
})

local hi_todo = function(words, hl_name)
  -- Examples: `NOTE` `NOTE:` ` NOTE ` ` NOTE:`
  -- PERF  asdasdasdasd
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
    perf = hi_todo({ "PERF" }, "UserHipatternsPerf"),
  },
})

-- custom project picker =====================================================
local project = require("config.project")

project.setup({
  event = "User",
  event_opts = { pattern = "GitBufOpen" },
  detect = function(path, data)
    return not utils.is_dot_home_project(path) and (data.git_root or vim.fs.root(path, ".git"))
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
      action = function()
        project.choose(entry)
      end,
    })
  end

  return items
end

starter.setup({
  autoopen = false,
  evaluate_single = true, -- trigger as soon as query is resolved
  items = {
    recent_projects(5),
    { name = "New Buffer", action = "enew", section = "Actions" },
    { name = "Project Open", action = project.pick, section = "Actions" },
    { name = "Config Edit", action = open_config_picker, section = "Actions" },
    { name = "Explore", action = files_cwd, section = "Actions" },
    { name = "Quit Neovim", action = "qall", section = "Actions" },
  },
  footer = "",
})

-- NOTE: We are already in VimEnter so we need to open manually
if vim.fn.argc() == 0 and vim.fn.line2byte(1) == -1 and vim.bo.buftype == "" then
  starter.open()
end

-- mini.icons ===================================================================

local icons = require("mini.icons")
local store = require("config.settings")

icons.setup({ lsp = store.icons.lsp })
icons.mock_nvim_web_devicons()
utils.once_lsp(icons.tweak_lsp_kind, { desc = "Tweak LSP kinds for mini.icons once" })

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
