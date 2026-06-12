vim.pack.add({
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/jay-babu/mason-nvim-dap.nvim" },
  { src = "https://github.com/igorlfs/nvim-dap-view", version = vim.version.range("1.*") },
})

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

-- DAP ============================================
local dap = require("dap")

local dap_icons = {
  Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
  Breakpoint = " ",
  BreakpointCondition = " ",
  BreakpointRejected = { " ", "DiagnosticError" },
  LogPoint = ".>",
}

for name, sign in pairs(dap_icons) do
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

vim.keymap.set("n", "<leader>dx", function()
  dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })

vim.keymap.set("n", "<leader>dX", function()
  dap.clear_breakpoints()
end, { desc = "Clear Breakpoins" })

vim.keymap.set("n", "<leader>dc", function()
  dap.continue()
end, { desc = "Run/Continue" })

vim.keymap.set("n", "<leader>dC", function()
  dap.run_to_cursor()
end, { desc = "Run to Cursor" })

vim.keymap.set("n", "<leader>dg", function()
  dap.goto_()
end, { desc = "Go to Line (No Execute)" })

vim.keymap.set("n", "<leader>di", function()
  dap.step_into()
end, { desc = "Step Into" })

vim.keymap.set("n", "<leader>dj", function()
  dap.down()
end, { desc = "Down" })

vim.keymap.set("n", "<leader>dk", function()
  dap.up()
end, { desc = "Up" })

vim.keymap.set("n", "<leader>dl", function()
  dap.run_last()
end, { desc = "Run Last" })

vim.keymap.set("n", "<leader>do", function()
  dap.step_out()
end, { desc = "Step Out" })

vim.keymap.set("n", "<leader>dO", function()
  dap.step_over()
end, { desc = "Step Over" })

vim.keymap.set("n", "<leader>dP", function()
  dap.pause()
end, { desc = "Pause" })

vim.keymap.set("n", "<leader>dr", function()
  dap.repl.toggle()
end, { desc = "Toggle REPL" })

vim.keymap.set("n", "<leader>ds", function()
  dap.session()
end, { desc = "Session" })

vim.keymap.set("n", "<leader>dt", function()
  dap.terminate()
end, { desc = "Terminate" })

-- DAP View =========================================
local dap_view = require("dap-view")

vim.keymap.set("n", "\\V", dap_view.virtual_text_toggle, { desc = "Toggle DAP virtual text" })

dap_view.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
  dap_view.virtual_text_enable()
  dap_view.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
  dap_view.virtual_text_disable()
  dap_view.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dap_view.virtual_text_disable()
  dap_view.close()
end

vim.keymap.set("n", "<leader>dK", function()
  dap_view.hover()
end, { desc = "Hover" })

-- highlight =======================================
vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
