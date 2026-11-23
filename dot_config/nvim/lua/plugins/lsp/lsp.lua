return {
  -- Mason lives in its own spec so `:Mason` (and friends) exist before any
  -- buffer is opened. `nvim-lspconfig` keeps it as a dependency below.
  {
    "williamboman/mason.nvim",
    cmd = {
      "Mason",
      "MasonInstall",
      "MasonUninstall",
      "MasonUninstallAll",
      "MasonUpdate",
      "MasonLog",
    },
    config = function()
      require("mason").setup({ ui = { border = "rounded" } })
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    config = function()
      -- Auto-install language tools; also triggered on startup via nvim-lspconfig.
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Lua
          "stylua",
          "lua-language-server",
          "selene",
          -- Python
          "pyright",
          "ruff",
          -- TypeScript
          "vtsls",
          "eslint-lsp",
          "prettier",
          "oxfmt",
          "oxlint",
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
          "sql-formatter",
          -- Shell
          "shfmt",
          "shellcheck",
          "bash-language-server",
          -- Docker
          "hadolint",
          "dockerfile-language-server",
          -- GitHub Actions
          "actionlint",
          -- Markdown
          "rumdl",
          "marksman",
          -- YAML (non-workflow)
          "yamllint",
          "tree-sitter-cli",
          "biome",
          -- Go
          "gopls",
          "gofumpt",
          "goimports",
          "golangci-lint",
          -- Structural search (used by grug-far `astgrep` engines)
          "ast-grep",
          -- Rust / TOML
          "taplo",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "b0o/schemastore.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- 1. Diagnostics
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

      -- 2. Rounded borders for LSP float windows
      local orig_open_floating_preview = vim.lsp.util.open_floating_preview
      vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return orig_open_floating_preview(contents, syntax, opts)
      end

      -- 3. Capabilities (for blink.cmp & lsp-file-operations)
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
              formatting = {
                defaultConfig = { indent_style = "space", indent_size = 2 },
              },
            },
          },
        },
        pyright = {
          cmd = { "pyright-langserver", "--stdio" },
          filetypes = { "python" },
          root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
            ".git",
          },
          capabilities = {
            window = {
              workDoneProgress = false,
            },
          },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
              },
            },
          },
        },
        ruff = {
          cmd = { "ruff", "server" },
          filetypes = { "python" },
          root_markers = {
            "pyproject.toml",
            "setup.py",
            "setup.cfg",
            "requirements.txt",
            "Pipfile",
            "pyrightconfig.json",
            ".git",
          },
        },
        vtsls = {
          cmd = { "vtsls", "--stdio" },
          filetypes = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
          },
          root_markers = {
            "turbo.json",
            "pnpm-workspace.yaml",
            "package.json",
            "tsconfig.json",
            "jsconfig.json",
            ".git",
          },
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = true },
              },
              tsserver = {
                maxTsServerMemory = 2048, -- 🚀 Cấp đủ 2048MB headroom cho Monorepo Next.js lớn không bị OOM crash
                disableAutomaticTypingAcquisition = true,
              },
              preferences = {
                includePackageJsonAutoImports = "auto",
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = true },
              },
            },
            vtsls = {
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
          },
        },
        html = {
          cmd = { "vscode-html-language-server", "--stdio" },
          filetypes = { "html" },
        },
        bashls = {
          cmd = { "bash-language-server", "start" },
          filetypes = { "sh", "bash" },
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.command|.zsh)",
            },
          },
        },
        dockerls = {
          cmd = { "docker-langserver", "--stdio" },
          filetypes = { "dockerfile" },
          root_markers = { "Dockerfile", "docker-compose.yml", ".git" },
        },
        marksman = {
          cmd = { "marksman", "server" },
          filetypes = { "markdown" },
          root_markers = { ".marksman.toml", ".git" },
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
          filetypes = {
            "html",
            "css",
            "javascriptreact",
            "typescriptreact",
          },
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
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas
              or {}
            vim.list_extend(
              new_config.settings.json.schemas,
              require("schemastore").json.schemas()
            )
          end,
          settings = {
            json = {
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
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
        eslint = {
          cmd = { "vscode-eslint-language-server", "--stdio" },
          root_markers = {
            "turbo.json",
            "pnpm-workspace.yaml",
            "package.json",
            ".git",
          },
          settings = {
            workingDirectories = { mode = "auto" }, -- 🚀 "auto" respects subpackage boundaries in Monorepos
            run = "onSave", -- 🚀 Run only on file save to prevent continuous AST memory churn
            format = false,
          },
        },
        gopls = {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { "go.work", "go.mod", ".git" },
          settings = {
            gopls = {
              gofumpt = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              completeUnimported = true,
              usePlaceholders = true,
            },
          },
        },
        taplo = {
          cmd = { "taplo", "lsp", "stdio" },
          filetypes = { "toml" },
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

        local ok, err = pcall(function()
          vim.lsp.config(server, config)
          vim.lsp.enable(server)
        end)
        if not ok then
          vim.notify(
            ("Failed to configure LSP server '%s': %s"):format(server, err),
            vim.log.levels.ERROR
          )
        end
      end

      -- Register LspStart, LspStop, and LspRestart commands for Neovim 0.11 native LSP
      vim.api.nvim_create_user_command("LspRestart", function(opts)
        local name = opts.args ~= "" and opts.args or nil
        local active_clients =
          vim.lsp.get_clients(name and { name = name } or {})

        if #active_clients == 0 then
          local msg = name and ("No active LSP client named " .. name)
            or "No active LSP clients"
          vim.notify(msg, vim.log.levels.WARN)
          return
        end

        for _, client in ipairs(active_clients) do
          local bufs = vim.tbl_keys(client.attached_buffers or {})
          local client_name = client.name
          client.stop()
          vim.defer_fn(function()
            for _, buf in ipairs(bufs) do
              if vim.api.nvim_buf_is_valid(buf) then
                vim.lsp.start(client.config, { bufs = { buf } })
              end
            end
            vim.notify(
              "Restarted LSP client: " .. client_name,
              vim.log.levels.INFO
            )
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
        local active_clients =
          vim.lsp.get_clients(name and { name = name } or {})

        if #active_clients == 0 then
          local msg = name and ("No active LSP client named " .. name)
            or "No active LSP clients"
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
          vim.notify(
            "Please specify an LSP client name to start",
            vim.log.levels.ERROR
          )
          return
        end

        local config = servers[name]
        if not config then
          vim.notify(
            "LSP client not configured: " .. name,
            vim.log.levels.ERROR
          )
          return
        end

        local final_config =
          vim.tbl_deep_extend("force", { name = name }, config)
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

      -- 4. LspAttach (Keymaps & Settings)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end

          local bufname = vim.api.nvim_buf_get_name(ev.buf)
          if bufname:match("^diffview://") or vim.bo[ev.buf].buftype ~= "" then
            vim.lsp.buf_detach_client(ev.buf, ev.data.client_id)
            return
          end

          -- Let Pyright handle hover docs & signatures; disable Ruff's hover
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          -- Big-file guard: no heavy LSP features on very large buffers
          if _G.is_big_file(ev.buf) then
            vim.lsp.buf_detach_client(ev.buf, ev.data.client_id)
            vim.notify_once(
              "Big file detected: LSP features disabled for this buffer",
              vim.log.levels.WARN
            )
            return
          end

          -- Remove Neovim 0.10 default gr... mappings to eliminate 300ms delay on `gr`
          pcall(vim.keymap.del, "n", "gra", { buffer = ev.buf })
          pcall(vim.keymap.del, "n", "gri", { buffer = ev.buf })
          pcall(vim.keymap.del, "n", "grn", { buffer = ev.buf })
          pcall(vim.keymap.del, "n", "grr", { buffer = ev.buf })
          pcall(vim.keymap.del, "n", "grt", { buffer = ev.buf })
          pcall(vim.keymap.del, "n", "grx", { buffer = ev.buf })

          -- Clean mnemonic LSP keybindings (single source: config.lsp_keymaps)
          for _, map in ipairs(require("config.lsp_keymaps")) do
            vim.keymap.set(map[1], map[2], map[3], {
              buffer = ev.buf,
              silent = true,
              desc = map[4],
            })
          end
        end,
      })
    end,
  },
}
