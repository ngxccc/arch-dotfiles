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
-- Mason is lazy-loaded, but `:Mason` always resolves thanks to its `cmd` trigger
vim.keymap.set("n", "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason: Package Manager" })

-- 🛡️ CLIPBOARD & REGISTERS
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set("n", "<leader>D", [["_dd]], { desc = "Delete current line to blackhole register" })
vim.keymap.set("x", "<leader>D", [["_d]], { desc = "Delete selection to blackhole register" })
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
  local session = vim.fn.expand("~/.local/share/nvim/last_session.vim")
  if vim.fn.filereadable(session) == 0 then
    vim.notify("No saved session found", vim.log.levels.WARN)
    return
  end
  local ok, err = pcall(vim.cmd.source, session)
  if ok then
    vim.notify("Global session restored successfully", vim.log.levels.INFO)
  else
    vim.notify("Failed to restore session: " .. tostring(err), vim.log.levels.ERROR)
  end
end, { desc = "Session Restore" })

-- 🌳 UNDOTREE
vim.keymap.set("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = "Toggle UndoTree" })

-- 📄 WORD WRAP TOGGLE (<leader>c group)
vim.keymap.set("n", "<leader>cw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.wo.linebreak = vim.wo.wrap
  vim.wo.breakindent = vim.wo.wrap
  local status = vim.wo.wrap and "ON" or "OFF"
  vim.notify("Word Wrap: " .. status, vim.log.levels.INFO)
end, { desc = "Toggle Word Wrap" })

-- 🔍 WHITESPACE TOGGLE (<leader>c group)
vim.keymap.set("n", "<leader>cW", function()
  vim.wo.list = not vim.wo.list
  local status = vim.wo.list and "ON" or "OFF"
  vim.notify("Whitespace (list): " .. status, vim.log.levels.INFO)
end, { desc = "Toggle Whitespace Dots" })
