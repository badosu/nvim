vim.opt.guifont = "IosevkaTerm Nerd Font Mono:h13"
vim.opt.winblend = 0

-- mitigate dumb cursor animation
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_cursor_animate_command_line = false

vim.g.neovide_window_blurred = true
vim.g.neovide_opacity = 0.9
vim.g.neovide_normal_opacity = 0.9

vim.g.neovide_floating_blur = true
vim.g.neovide_floating_blur_amount_x = 3.0
vim.g.neovide_floating_blur_amount_y = 3.0
vim.g.neovide_floating_shadow = true
vim.g.neovide_floating_z_height = 10
vim.g.neovide_floating_corner_radius = 0.8

vim.g.neovide_light_angle_degrees = 45
vim.g.neovide_light_radius = 5

-- Progress bar any good?
vim.g.neovide_progress_bar_enabled = true
vim.g.neovide_progress_bar_height = 10.0
vim.g.neovide_progress_bar_animation_speed = 200.0
vim.g.neovide_progress_bar_hide_delay = 0.2
