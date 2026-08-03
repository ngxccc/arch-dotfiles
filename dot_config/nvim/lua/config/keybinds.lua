-- KEYBINDS
vim.g.mapleader = " "
vim.g.maplocalleader = ","


-- ⚙️ CONFIG & CODE (<leader>c group)
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

-- 🚀 MOVEMENT & EDITING
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "Select entire file" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and keep selection" })
vim.keymap.set("v", "H", "^", { desc = "Move to start of line" })
vim.keymap.set("v", "L", "$h", { desc = "Move to end of line" })
vim.keymap.set("n", "H", "^", { desc = "Move to start of line" })
vim.keymap.set("n", "L", "$", { desc = "Move to end of line" })
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up (centered)" })
vim.keymap.set("n", "<leader>sh", ":nohlsearch<CR>", { silent = true, desc = "Search Highlight Clear" })
vim.keymap.set("n", "<leader>o", "o<Esc>", { desc = "Open line below" })
vim.keymap.set("n", "<leader>O", "O<Esc>", { desc = "Open line above" })

-- 🛡️ CLIPBOARD & REGISTERS
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting register" })
vim.keymap.set("n", "<leader>dl", "dd", { desc = "Delete current line" })
vim.keymap.set({ "n", "v" }, "<leader>D", [[_d]], { desc = "Delete to blackhole register" })
vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Escape insert mode properly" })

-- 💾 SAVE & QUIT
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set({ "n", "i", "v" }, "<C-q>", "<cmd>q<CR>", { desc = "Quit vim" })

-- 🚫 DISABLE MACROS
vim.keymap.set("n", "q", "<nop>", { desc = "Disable macro recording" })
vim.keymap.set({ "n", "x" }, "@", "<nop>", { desc = "Disable macro playback" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable macro replay / Ex mode" })

-- 🗃️ SESSION MANAGEMENT (<leader>S group)
vim.keymap.set("n", "<leader>Ss", function()
  vim.cmd("Neotree close")
  vim.cmd("mksession! ~/.local/share/nvim/last_session.vim")
  vim.notify("Global session saved successfully", vim.log.levels.INFO)
end, { desc = "Session Save" })

vim.keymap.set("n", "<leader>Sr", function()
  vim.cmd("source ~/.local/share/nvim/last_session.vim")
  vim.notify("Global session restored successfully", vim.log.levels.INFO)
end, { desc = "Session Restore" })

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

-- 🛠️ LSP & TOOLS (<leader>l group)
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

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle UndoTree" })

-- 📦 BUFFERS (<leader>b group)
vim.keymap.set("n", "<leader>bd", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo[bufnr].modified then
    local ok, err = pcall(vim.cmd, "bd " .. bufnr)
    if not ok then
      vim.notify(err:match("E%d+:.*") or err, vim.log.levels.ERROR)
    end
    return
  end

  local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })
  if #listed_buffers <= 1 then
    vim.cmd("enew")
  else
    vim.cmd("bp")
  end
  pcall(vim.cmd, "bd! " .. bufnr)
end, { desc = "Buffer Delete Current" })

vim.keymap.set("n", "<leader>ba", function()
  local buffers = vim.api.nvim_list_bufs()
  vim.cmd("enew")
  for _, bufnr in ipairs(buffers) do
    if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      pcall(vim.cmd, "bd! " .. bufnr)
    end
  end
  vim.notify("Closed all buffers", vim.log.levels.INFO)
end, { desc = "Buffer Delete All" })
vim.keymap.set("n", "<leader>bo", function()
  local current = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buffers) do
    if bufnr ~= current and vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
      pcall(vim.cmd, "bd " .. bufnr)
    end
  end
end, { desc = "Buffer Delete Others" })
-- 🔍 SEARCH & REPLACE (<leader>s group)
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "Search & Replace word in file" })

-- 🪟 WINDOW MANAGEMENT & NAVIGATION
vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<CR>", { desc = "Split Window Vertically" })
vim.keymap.set("n", "<leader>ws", "<cmd>split<CR>", { desc = "Split Window Horizontally" })
vim.keymap.set("n", "<leader>wc", "<cmd>close<CR>", { desc = "Close Current Window" })
vim.keymap.set("n", "<leader>wo", "<cmd>only<CR>", { desc = "Close Other Windows" })

-- Window Resizing & Cycling
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
vim.keymap.set("n", "<Tab>", "<C-w>w", { desc = "Cycle through windows", silent = true })
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
  vim.notify("Copied " .. #diagnostics .. " diagnostic(s) to clipboard")
end

vim.keymap.set("n", "<leader>yd", copy_line_diagnostics, { desc = "Yank Line Diagnostics" })

local function get_active_file_path()
  if vim.bo.filetype == "neo-tree" then
    local ok, state = pcall(require("neo-tree.sources.manager").get_state, "filesystem")
    if ok and state and state.tree then
      local node = state.tree:get_node()
      if node then
        return node:get_id(), node.name
      end
    end
  end
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
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

-- ↕️ MOVE & DUPLICATE LINES
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("n", "<A-J>", "yyp", { desc = "Duplicate line down" })
vim.keymap.set("n", "<A-K>", "yyP", { desc = "Duplicate line up" })
vim.keymap.set("v", "<A-J>", "Y'>p", { desc = "Duplicate block down" })
vim.keymap.set("v", "<A-K>", "Y'<P", { desc = "Duplicate block up" })

-- 🌿 GIT SHORTCUTS
vim.keymap.set("n", "<leader>ga", function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok then
    gitsigns.stage_buffer()
    vim.notify("Staged current buffer successfully")
  else
    vim.notify("Gitsigns not loaded", vim.log.levels.ERROR)
  end
end, { desc = "Git Add (Stage) Current File" })

-- 📤 AUTOMATIC KEYMAP EXPORT COMMAND
vim.api.nvim_create_user_command("ExportKeymaps", function()
  local keymaps = vim.api.nvim_get_keymap("n")
  local lines = {
    "# 🚀 Automatically Generated Neovim Keymaps",
    "",
    "Generated on: " .. os.date("%Y-%m-%d %H:%M:%S"),
    "",
    "| Keymap | Action / Description |",
    "| :--- | :--- |",
  }

  local desc_overrides = {
    ["vim.lsp.buf.code_action()"] = "LSP Code Action",
    ["vim.lsp.buf.implementation()"] = "LSP Go to Implementation",
    ["vim.lsp.buf.rename()"] = "LSP Rename Symbol",
    ["vim.lsp.buf.references()"] = "LSP Show References",
    ["vim.lsp.buf.type_definition()"] = "LSP Go to Type Definition",
    ["vim.lsp.buf.document_symbol()"] = "LSP Document Symbols",
    ["vim.lsp.codelens.run()"] = "LSP Run CodeLens",
  }

  local sorted_maps = {}
  local seen = {}
  for _, map in ipairs(keymaps) do
    local desc = map.desc
    if desc and (desc:sub(1, 6) == ":help " or desc:sub(1, 1) == ":") then
      desc = nil
    end

    if desc and desc ~= "" then
      desc = desc_overrides[desc] or desc
      local lhs = map.lhs:gsub(" ", "<leader>")
      if not seen[lhs] then
        seen[lhs] = true
        table.insert(sorted_maps, { lhs = lhs, desc = desc })
      end
    end
  end

  table.sort(sorted_maps, function(a, b) return a.lhs < b.lhs end)

  for _, map in ipairs(sorted_maps) do
    table.insert(lines, string.format("| **`%s`** | %s |", map.lhs, map.desc))
  end

  local file_path = vim.fn.stdpath("config") .. "/KEYMAPS_AUTOGEN.md"
  local f = io.open(file_path, "w")
  if f then
    f:write(table.concat(lines, "\n") .. "\n")
    f:close()
    vim.notify("Successfully exported clean keymaps to " .. file_path, vim.log.levels.INFO)
  else
    vim.notify("Failed to write keymaps file", vim.log.levels.ERROR)
  end
end, { desc = "Export all active keymaps to Markdown" })
