return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 300
    end,
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      { "<leader>b", group = "Buffers" },
      { "<leader>c", group = "Config / Code" },
      { "<leader>d", group = "Debug (DAP)" },
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>l", group = "LSP / Location" },
      { "<leader>m", group = "Markdown" },
      { "<leader>q", group = "Quickfix" },
      { "<leader>r", group = "Rust" },
      { "<leader>s", group = "Search / Replace" },
      { "<leader>S", group = "Session" },
      { "<leader>t", group = "Tabs" },
      { "<leader>w", group = "Window" },
      { "<leader>x", group = "Diagnostics (Trouble)" },
      { "<leader>y", group = "Yank / Copy" },
    }, {})

    wk.add({ { "gc", group = "Comment" } }, { mode = "n" })
  end,
}
