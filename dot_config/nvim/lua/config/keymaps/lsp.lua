-- 🛠️ LSP, DIAGNOSTICS, QUICKFIX & YANK UTILITIES

-- 🩺 DIAGNOSTICS & YANK (<leader>y group)
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to Previous Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to Next Diagnostic" })

local function copy_line_diagnostics()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diagnostics = vim.diagnostic.get(0, { lnum = line })
  if #diagnostics == 0 then
    vim.notify("No diagnostics on current line", vim.log.levels.WARN)
    return
  end
  local messages = {}
  for _, d in ipairs(diagnostics) do
    table.insert(messages, string.format("[%s] %s", d.code or d.source or "LSP", d.message))
  end
  local text = table.concat(messages, "\n")
  vim.fn.setreg("+", text)
  vim.notify("Copied " .. #diagnostics .. " diagnostic(s) to clipboard", vim.log.levels.INFO)
end

vim.keymap.set("n", "<leader>yd", copy_line_diagnostics, { desc = "Yank Line Diagnostics" })

-- 📋 PATH YANKING UTILITIES
local function get_active_file_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    return nil, nil
  end
  return path, vim.fn.fnamemodify(path, ":t")
end

vim.keymap.set("n", "<leader>yp", function()
  local abs_path, _ = get_active_file_path()
  if not abs_path then
    vim.notify("No valid file path to copy", vim.log.levels.WARN)
    return
  end
  local rel_path = vim.fn.fnamemodify(abs_path, ":.")
  vim.fn.setreg("+", rel_path)
  vim.notify("Copied relative path: " .. rel_path, vim.log.levels.INFO)
end, { desc = "Yank Relative Path" })

vim.keymap.set("n", "<leader>yP", function()
  local abs_path, _ = get_active_file_path()
  if not abs_path then
    vim.notify("No valid file path to copy", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", abs_path)
  vim.notify("Copied absolute path: " .. abs_path, vim.log.levels.INFO)
end, { desc = "Yank Absolute Path" })

vim.keymap.set("n", "<leader>yn", function()
  local _, name = get_active_file_path()
  if not name or name == "" then
    vim.notify("No valid file name to copy", vim.log.levels.WARN)
    return
  end
  vim.fn.setreg("+", name)
  vim.notify("Copied file name: " .. name, vim.log.levels.INFO)
end, { desc = "Yank File Name" })

-- 🛠️ LSP HEALTH & RESTART (<leader>l group)
vim.keymap.set("n", "<leader>li", ":checkhealth vim.lsp<CR>", { desc = "LSP Info Healthcheck" })
vim.keymap.set("n", "<leader>lr", function()
  pcall(vim.diagnostic.reset, nil, 0)
  if vim.fn.executable("eslint_d") == 1 then
    vim.fn.jobstart({ "eslint_d", "restart" })
  end
  if vim.fn.exists(":VtsExec") == 2 then
    pcall(vim.cmd, "VtsExec restart_tsserver")
  end
  vim.cmd("LspRestart")
  vim.cmd("edit")
  vim.notify("LSP & TS Cache reset successfully", vim.log.levels.INFO)
end, { desc = "LSP & TS Diagnostics Restart" })

-- 📋 QUICKFIX LIST (<leader>q group)
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { silent = true, desc = "Quickfix Open" })
vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { silent = true, desc = "Quickfix Close" })
vim.keymap.set("n", "<leader>qn", ":cnext<CR>zz", { desc = "Quickfix Next item" })
vim.keymap.set("n", "<leader>qp", ":cprev<CR>zz", { desc = "Quickfix Prev item" })

-- 📍 LOCATION LIST (<leader>l group)
vim.keymap.set("n", "<leader>lo", "<cmd>lopen<CR>zz", { desc = "Location List Open" })
vim.keymap.set("n", "<leader>lc", "<cmd>lclose<CR>", { desc = "Location List Close" })
vim.keymap.set("n", "<leader>ln", "<cmd>lnext<CR>zz", { desc = "Location List Next item" })
vim.keymap.set("n", "<leader>lp", "<cmd>lprev<CR>zz", { desc = "Location List Prev item" })
