return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    -- Options for LSP progress status
    progress = {
      display = {
        progress_icon = { pattern = "dots", period = 1 }, -- clean dot spinner
      },
    },
    notification = {
      window = {
        winblend = 0, -- fully opaque to match square style
      },
      configs = {
        default = {
          ttl = 10, -- Increase notification display time to 10 seconds
        },
      },
    },
  },
}
