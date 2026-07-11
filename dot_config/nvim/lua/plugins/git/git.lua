return {
  -- 1. vim-fugitive: The go-to Git CLI command interface
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  },

  -- 2. Diffview: VS Code-style diff viewer and conflict resolver
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

  -- 3. Neogit: Native Source Control Panel interface and Git Graph
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
      graph_style = "unicode", -- Render branch graph using Unicode characters for a smooth visual
      integrations = {
        diffview = true,
        telescope = true,
      },
    },
  },
}