return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true, -- Show hidden files (.env, .git, etc.)
      },
    },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory in Oil" },
    },
  },
}