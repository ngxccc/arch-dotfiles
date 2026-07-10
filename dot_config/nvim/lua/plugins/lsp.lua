return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "b0o/schemastore.nvim",
    "saghen/blink.cmp", -- Để lấy được capabilities
  },
  config = function()
    -- 1. Setup Mason
    require("mason").setup({ ui = { border = "rounded" } })

    -- 2. Auto Install Tools
    local tools = {
      -- Lua
      "stylua",
      "lua-language-server",
      -- Python
      "ruff",
      "mypy",
      -- TypeScript
      "typescript-language-server",
      "prettier",
      -- HTML
      "html-lsp",
      -- CSS
      "css-lsp",
      -- Tailwind CSS
      "tailwindcss-language-server",
      -- JSON
      "json-lsp",
      -- Prisma
      "prisma-language-server",
      -- SQL
      "sqls",
      -- Shell
      "shfmt",
      "shellcheck",
      "tree-sitter-cli",
      "biome",
      "markdownlint",
    }
    require("mason-tool-installer").setup({
      ensure_installed = tools,
    })

    -- 3. Config Diagnostics
    vim.diagnostic.config({
      virtual_text = false,
      float = { border = "rounded" },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
    })

    -- 4. Capabilities (cho blink.cmp & lsp-file-operations)
    local capabilities = require("blink.cmp").get_lsp_capabilities()
    local ok_file_ops, lsp_file_ops = pcall(require, "lsp-file-operations")
    if ok_file_ops then
      capabilities = vim.tbl_deep_extend(
        "force",
        capabilities,
        lsp_file_ops.default_capabilities()
      )
    end
    local servers = {
      lua_ls = {
        cmd = { "lua-language-server" },
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            format = { enable = true },
            telemetry = { enable = false },
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            formatting = { defaultConfig = { indent_style = "space", indent_size = 2 } },
          },
        },
      },
      ruff = {
        cmd = { "ruff", "server" },
        filetypes = { "python" },
        root_markers = { "pyproject.toml", ".git" },
      },
      ts_ls = {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
        root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
      },
      html = {
        cmd = { "vscode-html-language-server", "--stdio" },
      },
      cssls = {
        cmd = { "vscode-css-language-server", "--stdio" },
      },
      tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
        settings = {
          tailwindCSS = {
            experimental = { classRegex = {} },
            includeLanguages = {
              javascript = "javascript",
              typescript = "typescript",
              javascriptreact = "html",
              typescriptreact = "html",
            },
          },
        },
      },
      jsonls = {
        cmd = { "vscode-json-language-server", "--stdio" },
        settings = {
          json = {
            schemas = require("schemastore").json.schemas(),
            validate = { enable = true },
          },
        },
      },
      prismals = {
        cmd = { "prisma-language-server", "--stdio" },
        filetypes = { "prisma" },
      },
      sqls = {
        cmd = { "sqls" },
        filetypes = { "sql" },
      },
      biome = {
        cmd = { "biome", "lsp-server" },
        root_markers = { "biome.json", "biome.jsonc" },
      },
    }

    -- Vòng lặp thần thánh: Duyệt qua table và enable toàn bộ
    for server, config in pairs(servers) do
      -- Trộn capabilities mặc định vào config của từng server
      config.capabilities = vim.tbl_deep_extend(
        "force",
        {},
        capabilities,
        config.capabilities or {}
      )

      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end

    -- 5. LspAttach (Keymaps & Settings)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        -- Keybindings
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, silent = true, desc = "LSP Definition (Go to definition)" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, silent = true, desc = "LSP Hover Info" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = ev.buf, silent = true, desc = "LSP Implementation" })
        vim.keymap.set("n", "gr", function()
          local ok, builtin = pcall(require, "telescope.builtin")
          if ok then
            builtin.lsp_references()
          else
            vim.lsp.buf.references()
          end
        end, { buffer = ev.buf, silent = true, desc = "LSP References (Telescope)" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, silent = true, desc = "LSP Rename Symbol" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, silent = true, desc = "LSP Code Action" })
      end,
    })
  end,
}
