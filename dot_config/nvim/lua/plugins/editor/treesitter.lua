return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- Treesitter on the new main branch does not support lazy-loading
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Configure parser compilation arguments
    local install = require("nvim-treesitter.install")
    install.prefer_git = true
    -- Setup according to the new main branch standard (accepts install_dir only)
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Install desired parsers (replaces ensure_installed)
    require("nvim-treesitter").install({
      "json",
      "python",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "markdown",
      "markdown_inline",
      "bash",
      "lua",
      "vim",
      "vimdoc",
      "c",
      "dockerfile",
      "gitignore",
      "php",
      "sql",
      "graphql",
      "blade",
      "c_sharp",
      "xml",
      "razor",
    })

    -- Automatically enable Highlighting & Indent via Autocmd (Neovim 0.12+ standard)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        "json",
        "python",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "yaml",
        "html",
        "css",
        "markdown",
        "bash",
        "sh",
        "lua",
        "vim",
        "php",
        "sql",
        "graphql",
        "c",
        "dockerfile",
        "gitignore",
        "blade",
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
  end,
}