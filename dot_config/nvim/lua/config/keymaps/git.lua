-- 🌿 GIT SHORTCUTS (<leader>g group)

vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status (Changed Files Popup)" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git Branches Popup" })
vim.keymap.set("n", "<leader>gl", "<cmd>Telescope git_commits<cr>", { desc = "Git Commit Log Popup" })
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit Panel" })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git Diffview Open" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Git Diffview Close" })
vim.keymap.set("n", "<leader>ga", function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok then
    gitsigns.stage_buffer()
    vim.notify("Staged current buffer successfully", vim.log.levels.INFO)
  else
    vim.notify("Gitsigns not loaded", vim.log.levels.ERROR)
  end
end, { desc = "Git Add (Stage) Current File" })
