return {
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    keys = {
      { "<A-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<A-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
      { "<A-Left>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
      { "<A-Right>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thin",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        show_close_icon = false,
        name_formatter = function(buf)
          if vim.b[buf.bufnr] and vim.b[buf.bufnr].is_preview then
            return buf.name .. " ◦"
          end
          return buf.name
        end,
      },
    },
  },
}
