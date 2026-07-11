return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons", "echasnovski/mini.icons" },
  opts = {
    preset = "modern",
    delay = function(ctx)
      return ctx.plugin and 0 or 300
    end,
    -- keep spec empty here; we'll add mappings programmatically
    spec = {},
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Use new v3 mapping spec via `which-key`.add
    wk.add({
      { "<leader>b", group = "Buffers" },
      { "<leader>c", group = "Code / Quickfix" },
      { "<leader>d", group = "Delete" },
      { "<leader>e", group = "Explorer" },
      { "<leader>f", group = "Find/Telescope" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "Lists" },
      { "<leader>n", group = "No Highlight" },
      { "<leader>o", group = "Open" },
      { "<leader>s", group = "Search/Replace" },
      { "<leader>S", group = "Session" },
      { "<leader>u", group = "Undo" },
      { "<leader>x", group = "Tools" },
      { "<leader>y", group = "Yank" },
      { "<leader>z", group = "Zen" },
      { "<leader>h", group = "Harpoon" },
    }, {})
    -- explicit non-existent mappings are not added to avoid duplicates; which-key will use `desc` from keymaps

    -- Add a single mapping to label the comment operator prefix `gc`
    wk.add({ { "gc", group = "Comment" } }, { mode = "n" })
  end,
}
