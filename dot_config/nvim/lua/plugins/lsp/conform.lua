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
      javascriptreact = {
        "oxfmt",
        "biome",
        "prettier",
        stop_after_first = true,
      },
      typescriptreact = {
        "oxfmt",
        "biome",
        "prettier",
        stop_after_first = true,
      },
      css = { "prettier" },
      html = { "prettier" },
      json = { "oxfmt", "biome", "prettier", stop_after_first = true },
      jsonc = { "oxfmt", "biome", "prettier", stop_after_first = true },
      markdown = { "rumdl", "prettier" },
      go = { "goimports", "gofumpt" },
      sql = { "sql_formatter" },
      rust = { "rustfmt", lsp_format = "fallback" },
      toml = { "taplo" },
    }

    require("conform").setup({
      formatters_by_ft = formatters,
      format_on_save = function(bufnr)
        -- Never block saving huge files with a formatter
        if _G.is_big_file(bufnr) then
          return nil
        end
        return {
          timeout_ms = 1000,
          lsp_fallback = true,
        }
      end,
      formatters = {
        oxfmt = {
          condition = function(_, ctx)
            if not ctx.filename or ctx.filename == "" then
              return false
            end
            return #vim.fs.find(
              { ".oxfmtrc.json", ".oxfmtrc" },
              { path = ctx.dirname, upward = true }
            ) > 0
          end,
        },
        biome = {
          condition = function(_, ctx)
            if not ctx.filename or ctx.filename == "" then
              return false
            end
            return #vim.fs.find(
              { "biome.json", "biome.jsonc" },
              { path = ctx.dirname, upward = true }
            ) > 0
          end,
        },
        prettier = {
          condition = function(_, ctx)
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
            local has_oxfmt = #vim.fs.find(
              { ".oxfmtrc.json", ".oxfmtrc" },
              { path = ctx.dirname, upward = true }
            ) > 0
            local has_biome = #vim.fs.find(
              { "biome.json", "biome.jsonc" },
              { path = ctx.dirname, upward = true }
            ) > 0

            -- If neither oxfmt nor biome config exists, prettier acts as fallback
            return not (has_oxfmt or has_biome)
          end,
        },
        sql_formatter = {
          prepend_args = { "-l", "postgresql" },
        },
      },
    })
  end,
}
