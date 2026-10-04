-- ⚙️ GENERAL & CORE KEYMAPS
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- ⚙️ CONFIG & RELOAD (<leader>c group)
vim.keymap.set("n", "<leader>cr", function()
  local ft = vim.bo.filetype
  if ft == "lua" or ft == "vim" then
    vim.cmd("source %")
    vim.notify("🚀 Config reloaded: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
  else
    vim.notify("⚠️ Cannot source: current filetype is '" .. ft .. "'.", vim.log.levels.WARN)
  end
end, { desc = "Config Reload Current File" })

vim.keymap.set("n", "<leader>cR", "<cmd>source ~/.config/nvim/init.lua<cr>", { desc = "Config Reload All (init.lua)" })
vim.keymap.set("n", "<leader>cx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Code Make Executable (+x)" })

-- 🛡️ CLIPBOARD & REGISTERS
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set("n", "<leader>dl", "dd", { desc = "Delete current line" })
vim.keymap.set({ "n", "v" }, "<leader>D", [[_d]], { desc = "Delete to blackhole register" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode properly" })

-- 🚫 DISABLE MACROS
vim.keymap.set("n", "q", "<nop>", { desc = "Disable macro recording" })
vim.keymap.set({ "n", "x" }, "@", "<nop>", { desc = "Disable macro playback" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable macro replay / Ex mode" })

-- 🗃️ SESSION MANAGEMENT (<leader>S group)
vim.keymap.set("n", "<leader>Ss", function()
  vim.cmd("mksession! ~/.local/share/nvim/last_session.vim")
  vim.notify("Global session saved successfully", vim.log.levels.INFO)
end, { desc = "Session Save" })

vim.keymap.set("n", "<leader>Sr", function()
  vim.cmd("source ~/.local/share/nvim/last_session.vim")
  vim.notify("Global session restored successfully", vim.log.levels.INFO)
end, { desc = "Session Restore" })

-- 🌳 UNDOTREE
vim.keymap.set("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Toggle UndoTree" })
