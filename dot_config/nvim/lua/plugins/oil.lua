return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true, -- Hiển thị cả các file ẩn (.env, .git...)
      },
    },
    keys = {
      { "-", "<cmd>Oil<CR>", desc = "Open parent directory in Oil" },
    },
  },
}
