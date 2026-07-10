return {
  -- 1. Error Lens equivalent: Displays beautiful, highlighted diagnostics inline at the end of the line
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "LspAttach",
    priority = 1000, -- Load early
    config = function()
      require("tiny-inline-diagnostic").setup({
        preset = "classic", -- classic, powerline, ghost, modern
        options = {
          -- Show diagnostics on the line where the cursor is currently placed
          show_source = true,
          multiple_diag_under_cursor = true,
        },
      })
    end,
  },

  -- 2. Pretty TypeScript Errors equivalent: Translates cryptic TS errors into human-readable sentences
  {
    "dmmulroy/ts-error-translator.nvim",
    event = "VeryLazy",
    config = function()
      require("ts-error-translator").setup({
        auto_attach = true,
      })
    end,
  },
}
