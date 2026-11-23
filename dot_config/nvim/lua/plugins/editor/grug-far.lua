return {
  "MagicDuck/grug-far.nvim",
  opts = {
    headerMaxWidth = 80,
    engines = {
      ripgrep = {
        extraArgs = "--hidden --glob !.git",
      },
      astgrep = {
        -- `sg` is compiled as an alias of `ast-grep`; grug-far wants the full name
        path = "ast-grep",
      },
      ["astgrep-rules"] = {
        path = "ast-grep",
      },
    },
  },
  cmd = { "GrugFar" },
  keys = {
    {
      "<leader>sr",
      function()
        local grug = require("grug-far")
        grug.open({
          transient = true,
          prefills = {
            search = vim.fn.expand("<cword>"),
          },
        })
      end,
      mode = { "n", "v" },
      desc = "Search and Replace (GrugFar)",
    },
    {
      "<leader>sA",
      function()
        require("grug-far").open({
          engine = "astgrep",
          transient = true,
          prefills = {
            search = vim.fn.expand("<cword>"),
          },
        })
      end,
      mode = { "n", "v" },
      desc = "AST Structural Search (ast-grep)",
    },
  },
}
