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
      blade = { "blade-formatter" },
      json = { "biome", "prettier", stop_after_first = true },
      jsonc = { "biome", "prettier", stop_after_first = true },
      markdown = { "markdownlint", "prettier" },
    }

    require("conform").setup({
      formatters_by_ft = formatters,
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      formatters = {
        biome = {
          condition = function(self, ctx)
            if not ctx.filename or ctx.filename == "" then
              return false
            end
            return #vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.dirname, upward = true }) > 0
          end,
        },
        prettier = {
          condition = function(self, ctx)
            if not ctx.filename or ctx.filename == "" then
              return true -- Prettier acts as fallback for unnamed buffers
            end

            -- Check if prettier config exists
            local has_prettier = #vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }, { path = ctx.dirname, upward = true }) > 0

            if has_prettier then
              return true
            end

            -- Check if biome config exists
            local has_biome = #vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.dirname, upward = true }) > 0

            -- If no biome config exists, prettier acts as fallback
            return not has_biome
          end,
        },
      },
    })
  end,
}
