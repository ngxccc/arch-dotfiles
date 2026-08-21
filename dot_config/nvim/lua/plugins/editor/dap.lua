return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- 1. Setup Virtual Text
    require("nvim-dap-virtual-text").setup({
      commented = true,
    })

    -- 2. Setup DAP UI
    dapui.setup({
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.4 },
            { id = "breakpoints", size = 0.2 },
            { id = "stacks", size = 0.2 },
            { id = "watches", size = 0.2 },
          },
          size = 40,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.6 },
            { id = "console", size = 0.4 },
          },
          size = 12,
          position = "bottom",
        },
      },
    })

    -- 3. Auto open/close DAP UI
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- 4. Setup Mason DAP
    require("mason-nvim-dap").setup({
      ensure_installed = {
        "delve",
      },
      automatic_installation = true,
      handlers = {},
    })
    -- 6. Custom Icons & Highlights for Breakpoints
    vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#e51400" })
    vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = "#424242" })
    vim.api.nvim_set_hl(0, "DapStopped", { fg = "#e0af68", bg = "#292e42", bold = true })

    vim.fn.sign_define("DapBreakpoint", { text = "🔴", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "🟡", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "⚪", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "📝", texthl = "DapBreakpoint", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "▶️", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

    -- 7. Keymaps for Debugging (<leader>d group & F-keys)
    vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dB", function()
      vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
        if condition then dap.set_breakpoint(condition) end
      end)
    end, { desc = "Debug: Set Conditional Breakpoint" })
    vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "Debug: Start / Continue (F5)" })
    vim.keymap.set("n", "<leader>do", function() dap.step_over() end, { desc = "Debug: Step Over (F10)" })
    vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "Debug: Step Into (F11)" })
    vim.keymap.set("n", "<leader>dO", function() dap.step_out() end, { desc = "Debug: Step Out (Shift+F11)" })
    vim.keymap.set("n", "<leader>dt", function() dap.terminate() end, { desc = "Debug: Terminate / Stop" })
    vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "Debug: Toggle DAP UI" })
    vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "Debug: Open REPL" })
    vim.keymap.set({ "n", "v" }, "<leader>de", function() dapui.eval() end, { desc = "Debug: Evaluate Expression" })

    vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "Debug: Continue" })
    vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "Debug: Step Out" })
  end,
}
