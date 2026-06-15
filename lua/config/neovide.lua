vim.opt.guifont = "IosevkaTerm Nerd Font Mono:h14"
vim.opt.winblend = 0
vim.opt.pumblend = 0

-- mitigate dumb cursor animation
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_animate_command_line = false

vim.g.neovide_floating_corner_radius = 0.2

-- Progress bar any good?
vim.g.neovide_progress_bar_enabled = true
vim.g.neovide_progress_bar_height = 10.0
vim.g.neovide_progress_bar_animation_speed = 200.0
vim.g.neovide_progress_bar_hide_delay = 0.2
