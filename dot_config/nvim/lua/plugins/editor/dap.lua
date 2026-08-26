return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  cmd = { "DapContinue", "DapToggleBreakpoint" },
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
    {
      "<leader>dB",
      function()
        vim.ui.input({ prompt = "Breakpoint condition: " }, function(condition)
          if condition then require("dap").set_breakpoint(condition) end
        end)
      end,
      desc = "Debug: Set Conditional Breakpoint",
    },
    { "<leader>dc", function() require("dap").continue() end, desc = "Debug: Start / Continue (F5)" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Debug: Step Over (F10)" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into (F11)" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: Step Out (Shift+F11)" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Terminate / Stop" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle DAP UI" },
    { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
    { "<leader>de", function() require("dapui").eval() end, mode = { "n", "v" }, desc = "Debug: Evaluate Expression" },
    { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
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
  end,
}
