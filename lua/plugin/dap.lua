vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
  { src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
})

-- DAP ============================================
local dap = require("dap")

for name, sign in pairs(require("config.settings").icons.dap) do
  sign = type(sign) == "table" and sign or { sign }

  vim.fn.sign_define(
    "Dap" .. name,
    ---@diagnostic disable-next-line: assign-type-mismatch
    { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
  )
end

vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Breakpoint Condition" })

vim.keymap.set("n", "<leader>dx", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dX", dap.clear_breakpoints, { desc = "Clear Breakpoins" })
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Run/Continue" })
vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Run to Cursor" })
vim.keymap.set("n", "<leader>dg", dap.goto_, { desc = "Go to Line (No Execute)" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>dj", dap.down, { desc = "Down" })
vim.keymap.set("n", "<leader>dk", dap.up, { desc = "Up" })
vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dO", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dP", dap.pause, { desc = "Pause" })
vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
vim.keymap.set("n", "<leader>ds", dap.session, { desc = "Session" })
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "Terminate" })

-- DAP View =========================================
local dap_view = require("dap-view")

vim.keymap.set("n", "\\V", dap_view.virtual_text_toggle, { desc = "Toggle DAP virtual text" })

dap_view.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap_view.virtual_text_enable()
  dap_view.open()
end

local dapui_exited = function()
  dap_view.virtual_text_disable()
  dap_view.close()
end
dap.listeners.before.event_terminated["dapui_config"] = dapui_exited
dap.listeners.before.event_exited["dapui_config"] = dapui_exited

vim.keymap.set("n", "<leader>dK", dap_view.hover, { desc = "Hover (debug)" })

-- highlight ==================================================================
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

-- mason-nvim-dap ==============================================================

require("plugin.lsp")
---@diagnostic disable-next-line: missing-fields
require("mason-nvim-dap").setup({
  ensure_installed = { "python" },
  handlers = {
    -- all sources with no handler get passed here
    function(config)
      -- Keep original functionality
      require("mason-nvim-dap").default_setup(config)
    end,
  },
})
