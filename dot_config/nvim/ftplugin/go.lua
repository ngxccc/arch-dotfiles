-- Highlight Go Printf format specifiers (%v, %d, %s, %+v, %t, %T, %p, etc.)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = "*.go",
  callback = function()
    if not vim.w.go_format_specifier_match then
      vim.w.go_format_specifier_match = vim.fn.matchadd("goFormatSpecifier", "%[#%+%-0%s%*]*[%d%.%*]*[vsdTfqtbcoxXUpeEfgG]")
    end
  end,
})
