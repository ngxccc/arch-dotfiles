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
      javascript = { "oxfmt", "biome", "prettier", stop_after_first = true },
      typescript = { "oxfmt", "biome", "prettier", stop_after_first = true },
      javascriptreact = { "oxfmt", "biome", "prettier", stop_after_first = true },
      typescriptreact = { "oxfmt", "biome", "prettier", stop_after_first = true },
      css = { "prettier" },
      html = { "prettier" },
      blade = { "blade-formatter" },
      php = { "pint", "php_cs_fixer", stop_after_first = true },
      json = { "oxfmt", "biome", "prettier", stop_after_first = true },
      jsonc = { "oxfmt", "biome", "prettier", stop_after_first = true },
      markdown = { "markdownlint", "prettier" },
      cs = { "csharpier" },
      razor = { "prettier" },
      go = { "goimports", "gofumpt" },
      sql = { "sql_formatter" },
    }

    require("conform").setup({
      formatters_by_ft = formatters,
      format_on_save = {
        timeout_ms = 1000,
        lsp_fallback = true,
      },
      formatters = {
        oxfmt = {
          condition = function(self, ctx)
            if not ctx.filename or ctx.filename == "" then
              return false
            end
            return #vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc" }, { path = ctx.dirname, upward = true }) > 0
          end,
        },
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

            -- Check if oxfmt or biome config exists
            local has_oxfmt = #vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc" }, { path = ctx.dirname, upward = true }) > 0
            local has_biome = #vim.fs.find({ "biome.json", "biome.jsonc" }, { path = ctx.dirname, upward = true }) > 0

            -- If neither oxfmt nor biome config exists, prettier acts as fallback
            return not (has_oxfmt or has_biome)
          end,
          options = {
            ft_parsers = {
              razor = "html",
            },
          },
        },
        sql_formatter = {
          prepend_args = { "-l", "postgresql" },
        },
      },
    })
  end,
}
