return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "b0o/schemastore.nvim",
  },
  config = function()
    local profiles = require("config.profiles")

    local lua_tools = require("config.profiles.tools.lua")
    local python_tools = require("config.profiles.tools.python")
    local typescript_tools = require("config.profiles.tools.typescript")
    local html_tools = require("config.profiles.tools.html")
    local cssls_tools = require("config.profiles.tools.cssls")
    local tailwindcss_tools = require("config.profiles.tools.tailwindcss")
    local json_tools = require("config.profiles.tools.json")
    local prisma_tools = require("config.profiles.tools.prisma")
    local sql_tools = require("config.profiles.tools.sql")
    local shell_tools = require("config.profiles.tools.shell")

    local lua_servers = require("config.profiles.servers.lua")
    local python_servers = require("config.profiles.servers.python")
    local typescript_servers = require("config.profiles.servers.typescript")
    local html_servers = require("config.profiles.servers.html")
    local cssls_servers = require("config.profiles.servers.cssls")
    local tailwindcss_servers = require("config.profiles.servers.tailwindcss")
    local json_servers = require("config.profiles.servers.json")
    local prisma_servers = require("config.profiles.servers.prisma")
    local sql_servers = require("config.profiles.servers.sql")

    -- 1. Setup Mason
    require("mason").setup({ ui = { border = "rounded" } })

    -- 2. Auto Install Tools
    local tools = profiles.merge_list(
      lua_tools,
      python_tools,
      typescript_tools,
      html_tools,
      cssls_tools,
      tailwindcss_tools,
      json_tools,
      prisma_tools,
      sql_tools,
      shell_tools
    )
    require("mason-tool-installer").setup({
      ensure_installed = tools,
    })

    -- 3. Config Diagnostics
    vim.diagnostic.config({
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

    -- 4. Capabilities (cho cmp)
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = profiles.merge_maps(
      lua_servers,
      python_servers,
      typescript_servers,
      html_servers,
      cssls_servers,
      tailwindcss_servers,
      json_servers,
      prisma_servers,
      sql_servers
    )

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
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end,
    })

    -- 9. Setup nvim-cmp (như cũ của bạn, đã rút gọn cho ngắn)
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
      }),
    })
  end,
}
