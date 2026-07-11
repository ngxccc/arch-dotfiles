return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1001,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = false,
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
          },
        },
        custom_highlights = function(colors)
          return {
            NormalFloat = { bg = colors.mantle },
            FloatBorder = { fg = colors.blue, bg = colors.mantle },
          }
        end,
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
