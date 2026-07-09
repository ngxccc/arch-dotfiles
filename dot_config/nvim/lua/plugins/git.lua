return {
  -- 1. vim-fugitive: Lệnh Git CLI quốc dân
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  },

  -- 2. Diffview: Xem Diff & Giải quyết Conflict kiểu VS Code
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git Diffview Open" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Git Diffview Close" },
    },
    opts = {
      enhanced_diff_hl = true,
    }
  },

  -- 3. Neogit: Giao diện Source Control Panel & Git Graph native
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "Neogit" },
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Open Neogit Panel" },
      { "<leader>gc", "<cmd>Neogit commit<cr>", desc = "Neogit Commit" },
    },
    opts = {
      disable_commit_confirmation = true,
      graph_style = "unicode", -- Vẽ biểu đồ nhánh bằng ký tự Unicode siêu mượt
      integrations = {
        diffview = true,
        telescope = true,
      },
    },
  },
}
