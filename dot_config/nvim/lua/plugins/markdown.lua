return {
  -- 1. selimacerbas/markdown-preview.nvim: Pure Lua Markdown preview (no Node.js/npm required)
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    ft = { "markdown" },
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Toggle Markdown Preview (Browser)" },
      { "<leader>mS", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Markdown Preview Server" },
    },
    config = function()
      require("markdown_preview").setup({
        instance_mode = "takeover",
        open_browser = true,
        default_theme = "dark",
        debounce_ms = 300,
      })
    end,
  },

  -- 2. MeanderingProgrammer/render-markdown.nvim: Render Markdown visually directly inside Neovim
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- Requires Treesitter for rendering
    ft = { "markdown" },
    opts = {},
  },
}