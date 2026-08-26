return {
  "EmranMR/tree-sitter-blade",
  ft = "blade",
  init = function()
    vim.filetype.add({
      pattern = {
        [".*%.blade%.php"] = "blade",
      },
    })
  end,
}
