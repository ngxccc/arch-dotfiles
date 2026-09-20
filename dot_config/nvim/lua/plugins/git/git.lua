return {
  -- 1. vim-fugitive: The go-to Git CLI command interface
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  },

  -- 2. Diffview: VS Code-style diff viewer and conflict resolver
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    opts = {
      enhanced_diff_hl = true,
    },
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
    opts = {
      disable_commit_confirmation = true,
      graph_style = "unicode",
      integrations = {
        diffview = true,
        telescope = true,
      },
    },
  },
}
