return {
  "EmranMR/tree-sitter-blade",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    -- Register filetype
    vim.filetype.add({
      pattern = {
        [".*%.blade%.php"] = "blade",
      },
    })
  end,
}
