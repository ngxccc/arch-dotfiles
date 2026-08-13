return {
  {
    "mg979/vim-visual-multi",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.VM_default_mappings = 1
      vim.g.VM_maps = {
        ["Find Under"] = "<C-n>",
        ["Find Subword Under"] = "<C-n>",
        ["Add Cursor Down"] = "<C-A-j>",
        ["Add Cursor Up"] = "<C-A-k>",
        ["Exit"] = "<C-c>",
      }
    end,
  },
}
