return {
  {
    "stevearc/oil.nvim",
    cmd = { "Oil" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true, -- Show hidden files (.env, .git, etc.)
      },
    },
    keys = {
      { "-", function() require("oil").open() end, desc = "Open parent directory in Oil" },
      { "<leader>cd", function() require("oil").open() end, desc = "Open Oil File Manager" },
    },
  },
}