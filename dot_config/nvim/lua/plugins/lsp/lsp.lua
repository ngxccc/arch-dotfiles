return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "b0o/schemastore.nvim",
    "saghen/blink.cmp", -- To retrieve LSP capabilities
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
      "eslint-lsp",
      "prettier",
      "blade-formatter",
      -- PHP & Laravel
      "intelephense",
      "pint",
      "phpstan",
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
      -- .NET / C#
      "omnisharp",
      "csharpier",
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

    -- 3.5 Set global borders for LSP float windows via utility wrapper
    local orig_open_floating_preview = vim.lsp.util.open_floating_preview
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
      opts = opts or {}
      opts.border = opts.border or "rounded"
      return orig_open_floating_preview(contents, syntax, opts)
    end

    -- 3.6 Filter out disabled LSP code actions (prevent showing inapplicable refactorings)
    -- Intercepting at the protocol response level to cover all UI callers (Telescope, Dressing, etc.)
    local orig_code_action_handler = vim.lsp.handlers["textDocument/codeAction"]
    vim.lsp.handlers["textDocument/codeAction"] = function(err, result, ctx, config)
      if result then
        local filtered = {}
        for _, action in ipairs(result) do
          if not action.disabled then
            table.insert(filtered, action)
          end
        end
        result = filtered
      end
      return orig_code_action_handler(err, result, ctx, config)
    end
    -- 4. Capabilities (for blink.cmp & lsp-file-operations)
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
        settings = {
          css = {
            lint = {
              unknownAtRules = "ignore",
            },
          },
        },
      },
      tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = { "html", "css", "javascriptreact", "typescriptreact" },
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
        cmd = { "biome", "lsp-proxy" },
        root_markers = { "biome.json", "biome.jsonc" },
      },
      eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        settings = {
          workingDirectories = { mode = "location" },
        },
      },
      omnisharp = {
        cmd = { "omnisharp" },
        settings = {
          FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = true,
          },
          MsBuild = {
            LoadProjectsOnDemand = false,
          },
          RoslynExtensionsOptions = {
            EnableDecompilationSupport = true,
            EnableImportCompletion = true,
            EnableAnalyzersSupport = true,
          },
        },
      },
      intelephense = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_markers = { "composer.json", ".git" },
        settings = {
          intelephense = {
            files = { maxSize = 5000000 },
            completion = {
              insertUseDeclaration = true,
              fullyQualifyImportNames = false,
              triggerParameterHints = true,
            },
          },
        },
      },
    }

    -- Iterate over the servers table and enable all
    for server, config in pairs(servers) do
      -- Merge default capabilities into each server's config
      config.capabilities = vim.tbl_deep_extend(
        "force",
        {},
        capabilities,
        config.capabilities or {}
      )


      pcall(function()
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end)
    end

    -- Register LspStart, LspStop, and LspRestart commands for Neovim 0.11 native LSP
    vim.api.nvim_create_user_command("LspRestart", function(opts)
      local name = opts.args ~= "" and opts.args or nil
      local active_clients = vim.lsp.get_clients(name and { name = name } or {})

      if #active_clients == 0 then
        local msg = name and ("No active LSP client named " .. name) or "No active LSP clients"
        vim.notify(msg, vim.log.levels.WARN)
        return
      end

      for _, client in ipairs(active_clients) do
        local bufs = vim.lsp.get_buffers_by_client_id(client.id)
        local client_name = client.name
        client.stop()
        vim.defer_fn(function()
          for _, buf in ipairs(bufs) do
            if vim.api.nvim_buf_is_valid(buf) then
              vim.lsp.start(client.config, { bufs = { buf } })
            end
          end
          vim.notify("Restarted LSP client: " .. client_name, vim.log.levels.INFO)
        end, 200)
      end
    end, {
      nargs = "?",
      complete = function()
        local clients = vim.lsp.get_clients()
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return names
      end,
    })

    vim.api.nvim_create_user_command("LspStop", function(opts)
      local name = opts.args ~= "" and opts.args or nil
      local active_clients = vim.lsp.get_clients(name and { name = name } or {})

      if #active_clients == 0 then
        local msg = name and ("No active LSP client named " .. name) or "No active LSP clients"
        vim.notify(msg, vim.log.levels.WARN)
        return
      end

      for _, client in ipairs(active_clients) do
        client.stop()
        vim.notify("Stopped LSP client: " .. client.name, vim.log.levels.INFO)
      end
    end, {
      nargs = "?",
      complete = function()
        local clients = vim.lsp.get_clients()
        local names = {}
        for _, c in ipairs(clients) do
          table.insert(names, c.name)
        end
        return names
      end,
    })

    vim.api.nvim_create_user_command("LspStart", function(opts)
      local name = opts.args ~= "" and opts.args or nil
      if not name then
        vim.notify("Please specify an LSP client name to start", vim.log.levels.ERROR)
        return
      end

      local config = servers[name]
      if not config then
        vim.notify("LSP client not configured: " .. name, vim.log.levels.ERROR)
        return
      end

      local final_config = vim.tbl_deep_extend("force", { name = name }, config)
      vim.lsp.start(final_config)
      vim.notify("Started LSP client: " .. name, vim.log.levels.INFO)
    end, {
      nargs = "?",
      complete = function()
        local names = {}
        for name, _ in pairs(servers) do
          table.insert(names, name)
        end
        return names
      end,
    })

    -- 5. LspAttach (Keymaps & Settings)
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
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
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, silent = true, desc = "LSP Code Action" })
      end,
    })
  end,
}