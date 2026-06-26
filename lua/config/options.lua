-- Use treesitter syntax highlighting
vim.cmd.syntax("off")

-- stylua: ignore start

-- Disable default providers to save startup time
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider    = 0
vim.g.loaded_node_provider    = 0
vim.g.loaded_perl_provider    = 0

-- Prevent loading legacy/unnecessary plugins
vim.g.loaded_gzip             = 1
vim.g.loaded_zip              = 1
vim.g.loaded_tar              = 1
vim.g.loaded_tarPlugin        = 1
vim.g.loaded_zipPlugin        = 1

-- Have netrw usable
vim.g.netrw_banner            = false

-- Emit title when
vim.opt.title                 = true -- emit title name to host
vim.opt.clipboard             = "unnamed"
vim.opt.swapfile              = false
vim.opt.laststatus            = 3
vim.opt.confirm               = true

-- General ====================================================================
vim.g.mapleader               = ' '           -- Use `<Space>` as <Leader> key

vim.opt.mouse                 = 'a'           -- Enable mouse
vim.opt.mousescroll           = 'ver:6,hor:6' -- Customize mouse scroll
vim.opt.switchbuf             = 'usetab'      -- Use already opened buffers when switching
vim.opt.undofile              = true          -- Enable persistent undo

vim.opt.shada                 = "'20,<50,s10" -- Limit ShaDa file (for startup)

-- UI =========================================================================
vim.opt.breakindent           = true                -- Indent wrapped lines to match line start
vim.opt.breakindentopt        = 'list:-1'           -- Add padding for lists (if 'wrap' is set)
vim.opt.cursorline            = true                -- Enable current line highlighting
vim.opt.linebreak             = true                -- Wrap lines at 'breakat' (if 'wrap' is set)
vim.opt.list                  = true                -- Show helpful text indicators
vim.opt.number                = true                -- Show line numbers
vim.opt.numberwidth           = 1
vim.opt.pumheight             = 10                  -- Make popup menu smaller
vim.opt.pummaxwidth           = 100                 -- Make popup menu not too wide
vim.opt.shortmess             = 'CFOSWaco'          -- Disable some built-in completion messages
vim.opt.signcolumn            = 'auto:4'            -- Show up to 4 signs in the signcolumn
vim.opt.splitbelow            = true                -- Horizontal splits will be below
vim.opt.splitkeep             = 'screen'            -- Reduce scroll during window split
vim.opt.splitright            = true                -- Vertical splits will be to the right
vim.opt.wrap                  = false               -- Don't visually wrap lines (toggle with \w)
vim.opt.scrolloff             = 4                   -- When scrolling have context above/below
vim.opt.cursorlineopt         = 'screenline,number' -- Show cursor line per screen line

-- Special UI symbols. More is set via 'mini.basics' later.
vim.opt.fillchars             = 'eob: ,fold:╌'
vim.opt.listchars             = 'extends:…,nbsp:␣,precedes:…,tab:> ,trail:·'

-- Folds (see `:h fold-commands`, `:h zM`, `:h zR`, `:h zA`, `:h zj`)
vim.opt.foldlevel             = 10                                -- Fold nothing by default; set to 0 or 1 to fold
vim.opt.foldmethod            = 'expr'                            -- Fold based on indent level
vim.opt.foldexpr              = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldnestmax           = 10                                -- Limit number of fold levels
vim.opt.foldtext              = ''                                -- Show text under fold with its highlighting

-- Editing ====================================================================
vim.opt.formatoptions         = 'rqnl1j' -- Improve comment editing
vim.opt.ignorecase            = true     -- Ignore case during search
vim.opt.incsearch             = true     -- Show search matches while typing
vim.opt.infercase             = true     -- Infer case in built-in completion
vim.opt.smartcase             = true     -- Respect case if search pattern has upper case
vim.opt.smartindent           = true     -- Make indenting smart
vim.opt.virtualedit           = 'block'  -- Allow going past end of line in blockwise mode

-- Built-in completion
vim.opt.complete              = ''                              -- Only lsp completions
vim.opt.completeopt           = 'menuone,noselect,fuzzy,nosort' -- Use custom behavior
-- vim.opt.completetimeout       = 100                          -- Limit sources delay
