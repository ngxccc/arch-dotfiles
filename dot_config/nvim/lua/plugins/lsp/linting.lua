return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      -- Lua: selene (Rust binary, no luarocks needed, `std = "vim"` in selene.toml)
      lua = { "selene" },
      -- Python diagnostics come from pyright + ruff LSP; mypy is left to CI
      sh = { "shellcheck" },
      bash = { "shellcheck" },
      dockerfile = { "hadolint" },
      markdown = { "rumdl" },
      go = { "golangcilint" },
      -- NOTE: actionlint/yamllint are conditional, see `linters_for()` below.
    }

    -- rumdl reads its global config from `~/.config/rumdl/rumdl.toml` and
    -- project configs from `rumdl.toml` / `.rumdl.toml`, so no args override needed.
    -- nvim-lint 0.x ships `stream = "stderr"` for rumdl, but rumdl 0.3 writes
    -- its JSON report to stdout → without this the parser always sees "".
    lint.linters.rumdl.stream = "stdout"

    local function buf_dir(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      return name ~= "" and vim.fs.dirname(name) or nil
    end

    -- actionlint only makes sense for `.github/workflows/*.yml|yaml`
    local function is_workflow(bufnr)
      local name = vim.api.nvim_buf_get_name(bufnr)
      return name:match("/%.github/workflows/[^/]+%.ya?ml$") ~= nil
    end

    -- oxlint only when the project opts in with an oxlint config file
    local function has_oxlint_config(bufnr)
      local dir = buf_dir(bufnr)
      return dir ~= nil
        and #vim.fs.find(
            { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.config.ts" },
            { path = dir, upward = true }
          )
          > 0
    end

    --- Resolve the linter list for a buffer: filetype linters + conditional ones.
    local function linters_for(bufnr)
      local linters = {}
      local ft = vim.bo[bufnr].filetype
      for _, part in ipairs(vim.split(ft, ".", { plain = true })) do
        vim.list_extend(linters, lint.linters_by_ft[part] or {})
      end

      if ft:match("^ya?ml") then
        if is_workflow(bufnr) then
          -- actionlint owns workflows; yamllint would only add noise there
          if vim.fn.executable("actionlint") == 1 then
            table.insert(linters, "actionlint")
          end
          linters = vim.tbl_filter(function(name)
            return name ~= "yamllint"
          end, linters)
        elseif vim.fn.executable("yamllint") == 1 then
          table.insert(linters, "yamllint")
        end
      elseif
        (
          ft == "javascript"
          or ft == "typescript"
          or ft == "javascriptreact"
          or ft == "typescriptreact"
        )
        and vim.fn.executable("oxlint") == 1
        and has_oxlint_config(bufnr)
      then
        table.insert(linters, "oxlint")
      end

      return linters
    end

    -- Automatically run the linter on file save only (removed InsertLeave to avoid high CPU churn on large repos)
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = vim.api.nvim_create_augroup("UserLinting", { clear = true }),
      callback = function(args)
        if _G.is_big_file(args.buf) then
          return
        end
        lint.try_lint(linters_for(args.buf))
      end,
    })
  end,
}
