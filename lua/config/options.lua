-- Use treesitter syntax highlighting
vim.cmd.syntax("off")

-- Disable default providers to save startup time
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Prevent loading legacy/unnecessary plugins
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1

-- Have netrw usable
vim.g.netrw_banner = false

local utils = require("utils")

-- stylua: ignore start
vim.opt.title           = true
vim.opt.clipboard       = "unnamed"
vim.opt.swapfile        = false
vim.opt.laststatus      = 3
vim.opt.confirm         = true

-- General ====================================================================
vim.g.mapleader         = ' '                              -- Use `<Space>` as <Leader> key

vim.opt.mouse           = 'a'                              -- Enable mouse
vim.opt.mousescroll     = 'ver:6,hor:6'                    -- Customize mouse scroll
vim.opt.switchbuf       = 'usetab'                         -- Use already opened buffers when switching
vim.opt.undofile        = true                             -- Enable persistent undo

vim.opt.shada           = "'20,<50,s10"                    -- Limit ShaDa file (for startup)

-- UI =========================================================================
vim.opt.breakindent     = true                -- Indent wrapped lines to match line start
vim.opt.breakindentopt  = 'list:-1'           -- Add padding for lists (if 'wrap' is set)
vim.opt.colorcolumn     = '+1'                -- Draw column on the right of maximum width
vim.opt.cursorline      = true                -- Enable current line highlighting
vim.opt.linebreak       = true                -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.opt.list            = true                -- Show helpful text indicators
vim.opt.number          = true                -- Show line numbers
-- vim.opt.pumborder       = 'rounded'           -- Use border in popup menu
vim.opt.pumheight       = 10                  -- Make popup menu smaller
vim.opt.pummaxwidth     = 100                 -- Make popup menu not too wide
vim.opt.ruler           = false               -- Don't show cursor coordinates
vim.opt.shortmess       = 'CFOSWaco'          -- Disable some built-in completion messages
vim.opt.signcolumn      = 'auto:4'            -- Show up to 4 signs in the signcolumn
vim.opt.splitbelow      = true                -- Horizontal splits will be below
vim.opt.splitkeep       = 'screen'            -- Reduce scroll during window split
vim.opt.splitright      = true                -- Vertical splits will be to the right
-- vim.opt.winborder       = 'rounded'           -- Use round border in floating windows
vim.opt.wrap            = false               -- Don't visually wrap lines (toggle with \w)
vim.opt.scrolloff       = 4                   -- When scrolling have context above/below

vim.opt.cursorlineopt   = 'screenline,number' -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
vim.opt.fillchars       = 'eob: ,fold:╌'
vim.opt.listchars       = 'extends:…,nbsp:␣,precedes:…,tab:> '

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
vim.opt.foldlevel       = 10                                -- Fold nothing by default; set to 0 or 1 to fold
vim.opt.foldmethod      = 'expr'                            -- Fold based on indent level
vim.opt.foldexpr        = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldnestmax     = 10                                -- Limit number of fold levels
vim.opt.foldtext        = ''                                -- Show text under fold with its highlighting

-- Editing ====================================================================
vim.opt.formatoptions   = 'rqnl1j'              -- Improve comment editing
vim.opt.ignorecase      = true                  -- Ignore case during search
vim.opt.incsearch       = true                  -- Show search matches while typing
vim.opt.infercase       = true                  -- Infer case in built-in completion
vim.opt.smartcase       = true                  -- Respect case if search pattern has upper case
vim.opt.smartindent     = true                  -- Make indenting smart
vim.opt.virtualedit     = 'block'               -- Allow going past end of line in blockwise mode

vim.opt.iskeyword       = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.opt.formatlistpat   = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.opt.complete        = '.,w,b,kspell'                  -- Use less sources
vim.opt.completeopt     = 'menuone,noselect,fuzzy,nosort' -- Use custom behavior
vim.opt.completetimeout = 100                             -- Limit sources delay

local diagnostic_opts = {
  -- Show signs on top of any other sign, but only for warnings and errors
  signs = {
    -- priority = 9999, severity = { min = 'ERROR', max = 'ERROR' } ,
    text = require("config.settings").diagnostic_signs,
  },

  -- Show all diagnostics as underline
  underline = { severity = { min = "HINT", max = "ERROR" } },

  -- Show more details immediately for errors on the current line
  virtual_lines = false,

  virtual_text = {
    current_line = true,
    severity = { min = "ERROR", max = "ERROR" },
  },

  -- Don't update diagnostics when typing
  update_in_insert = false,
}

-- Whether any LSP client has ever attached
vim.g.lsp_was_ever_attached = false

utils.once("LspAttach", function()
  vim.g.lsp_was_ever_attached = true
  vim.lsp.document_color.enable(true, nil, { style = "virtual" })
  vim.diagnostic.config(diagnostic_opts)
end, { desc = "Configure LSP options" })

utils.on("FileType", function()
  -- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
  -- Do on `FileType` to always override these changes from filetype plugins.
  vim.cmd("setlocal formatoptions-=c formatoptions-=o")
end, { desc = "Proper 'formatoptions'" })
