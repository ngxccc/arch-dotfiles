return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- Treesitter mới trên main branch không hỗ trợ lazy-loading
  build = ":TSUpdate",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Cài đặt đối số biên dịch parser
    local install = require("nvim-treesitter.install")
    install.prefer_git = true
    -- Cấu hình setup theo chuẩn main branch mới (chỉ nhận install_dir)
    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })

    -- Cài đặt các parser mong muốn (thay cho ensure_installed)
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
    })

    -- Tự động bật Highlighting & Indent bằng Autocmd (theo chuẩn Neovim 0.12+)
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
      },
      callback = function()
        vim.treesitter.start()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Cấu hình độc lập cho các plugin bổ trợ (dependencies)
    require("nvim-ts-autotag").setup({})

    require("nvim-treesitter-textobjects").setup({
      select = {
        enable = true,
        lookahead = true,
      },
    })

    -- Cấu hình phím tắt cho Textobjects bằng vim.keymap.set theo API mới
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
