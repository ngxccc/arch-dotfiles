return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.icons" },
  opts = {
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 300
    end,
    spec = {},
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    wk.add({
      { "<leader>b", group = "Buffers" },
      { "<leader>c", group = "Config / Code" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP / Location" },
      { "<leader>q", group = "Quickfix" },
      { "<leader>s", group = "Search / Replace" },
      { "<leader>S", group = "Session" },
      { "<leader>y", group = "Yank / Copy" },
      { "<leader>u", group = "Undo" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>w", group = "Window" },
    }, {})

    wk.add({ { "gc", group = "Comment" } }, { mode = "n" })
  end,
}
