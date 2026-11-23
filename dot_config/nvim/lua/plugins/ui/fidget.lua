return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  opts = {
    -- Options for LSP progress status
    progress = {
      suppress_on_insert = true,                          -- Do not show progress updates in insert mode
      ignore_done_already = true,                         -- Ignore instantaneous tasks that are already complete
      ignore = { "pyright" },                             -- Pyright sends continuous analysis notifications on every keystroke
      display = {
        progress_icon = { pattern = "dots", period = 1 }, -- clean dot spinner
        done_ttl = 0.5,                                   -- Remove completed tasks quickly to avoid stacking
      },
    },
    notification = {
      window = {
        winblend = 0, -- fully opaque to match square style
      },
      configs = {
        default = {
          ttl = 3,
        },
      },
    },
  },
}
