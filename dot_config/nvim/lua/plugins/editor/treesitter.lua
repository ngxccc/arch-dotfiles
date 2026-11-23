return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstallDefaults", "TSUpdate" },
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Setup according to the new main branch standard (accepts install_dir only)
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Register command to install default parsers on demand (instead of running on every startup)
    vim.api.nvim_create_user_command("TSInstallDefaults", function()
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter").install({
        "json", "python", "javascript", "typescript", "tsx", "yaml",
        "html", "css", "markdown", "markdown_inline", "bash", "lua",
        "vim", "vimdoc", "c", "dockerfile", "gitignore",
        "sql", "graphql", "xml",
        "go", "gomod", "gowork", "gotmpl",
        "rust", "ron", "toml",
      })
    end, { desc = "Install all default Treesitter parsers" })

    -- Automatically enable Highlighting & Indent with Big-File Safeguard
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "json", "python", "javascript", "javascriptreact", "typescript",
        "typescriptreact", "yaml", "html", "css", "markdown", "bash",
        "sh", "lua", "vim", "sql", "graphql", "c", "dockerfile",
        "gitignore", "go", "gomod", "gowork", "gotmpl",
        "rust", "ron", "toml",
      },
      callback = function(args)
        local bufnr = args.buf
        -- Big file safeguard: disable treesitter + auto-indent (AGENTS invariant)
        if _G.is_big_file(bufnr) then
          vim.bo[bufnr].indentexpr = ""
          vim.bo[bufnr].autoindent = false
          return
        end

        pcall(vim.treesitter.start, bufnr)
        vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Standalone configuration for supplementary plugins (dependencies)
    require("nvim-ts-autotag").setup({})

    require("nvim-treesitter-textobjects").setup({
      select = {
        enable = true,
        lookahead = true,
      },
    })

    -- Configure Textobject keymaps using vim.keymap.set with the new API
    vim.keymap.set({ "x", "o" }, "af", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
    end, { desc = "Select outer function" })

    vim.keymap.set({ "x", "o" }, "if", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
    end, { desc = "Select inner function" })

    vim.keymap.set({ "x", "o" }, "ac", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
    end, { desc = "Select outer class" })

    vim.keymap.set({ "x", "o" }, "ic", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
    end, { desc = "Select inner class" })

    -- Move between functions and classes using ]f, [f, ]c, [c
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
    end, { desc = "Next Function Start" })

    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
    end, { desc = "Previous Function Start" })

    vim.keymap.set({ "n", "x", "o" }, "]F", function()
      require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
    end, { desc = "Next Function End" })

    vim.keymap.set({ "n", "x", "o" }, "[F", function()
      require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
    end, { desc = "Previous Function End" })

    vim.keymap.set({ "n", "x", "o" }, "]c", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
    end, { desc = "Next Class Start" })

    vim.keymap.set({ "n", "x", "o" }, "[c", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
    end, { desc = "Previous Class Start" })
  end,
}
