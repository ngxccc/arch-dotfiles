return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  config = function()
    local formatters = {
      lua = { "stylua" },
      python = { "ruff_format" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      javascript = { "biome", "prettier", stop_after_first = true },
      typescript = { "biome", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettier", stop_after_first = true },
      css = { "prettier" },
      html = { "prettier" },
      json = { "biome", "prettier", stop_after_first = true },
      jsonc = { "biome", "prettier", stop_after_first = true },
    }

    require("conform").setup({
      formatters_by_ft = formatters,
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
    })
  end,
}
