return {
  "MagicDuck/grug-far.nvim",
  opts = {
    headerMaxWidth = 80,
    engines = {
      ripgrep = {
        extraArgs = "--hidden --glob !.git",
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
  },
}
