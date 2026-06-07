return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    "windwp/nvim-ts-autotag",
  },
  config = function()
    -- Không cần pcall rườm rà, Lazy.nvim đã lo vụ bảo hiểm sinh mạng cho Neovim rồi!
    local install = require("nvim-treesitter.install")
    install.ts_generate_args = { "generate", "--abi", tostring(vim.treesitter.language_version) }
    require("nvim-treesitter.configs").setup({
      prefer_git = true,
      -- Kích hoạt highlight dựa trên AST
      highlight = {
        enable = true,
        -- Tắt highlight mặc định của Vim để tránh đụng độ và nặng máy
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },

      -- Setup riêng cho autotag hoạt động mượt mà với HTML, TSX, JSX
      autotag = { enable = true },

      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Tự động nhảy tới function gần nhất nếu con trỏ chưa nằm trong function
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            -- Nên thêm cái này để thao tác với class/struct
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },

      ensure_installed = {
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
      },
      auto_install = true,
    })
  end,
}
