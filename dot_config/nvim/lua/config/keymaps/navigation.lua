-- 🚀 NAVIGATION, WINDOWS, TABS & BUFFERS

-- 🏃 MOTIONS & BASIC EDITING
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

-- 🔍 SEARCH & REPLACE (<leader>s group)
vim.keymap.set("n", "<leader>sb", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "Search & Replace word in buffer" })

-- 📑 TAB MANAGEMENT (<leader>t group & bracket motions)
vim.keymap.set("n", "<leader>ta", "<cmd>tabnew<CR>", { silent = true, desc = "Tab New" })
vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<CR>", { silent = true, desc = "Tab Close" })
vim.keymap.set("n", "<leader>to", "<cmd>tabonly<CR>", { silent = true, desc = "Tab Only (Close others)" })
vim.keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { silent = true, desc = "Tab Next" })
vim.keymap.set("n", "<leader>tp", "<cmd>tabprevious<CR>", { silent = true, desc = "Tab Previous" })
vim.keymap.set("n", "]t", "gt", { desc = "Next Tab" })
vim.keymap.set("n", "[t", "gT", { desc = "Previous Tab" })

-- 📦 BUFFERS (<leader>b group & Alternate Toggle)
local function show_file_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" or vim.bo[bufnr].buftype ~= "" then
    vim.notify("Not a valid file buffer", vim.log.levels.WARN, { title = "Buffer Info" })
    return
  end

  local filename = vim.fn.fnamemodify(filepath, ":t")
  local rel_path = vim.fn.fnamemodify(filepath, ":.")
  local file_type = vim.bo[bufnr].filetype
  if file_type == "" then
    file_type = "plain text"
  end
  local encoding = vim.bo[bufnr].fileencoding
  if encoding == "" then
    encoding = vim.o.encoding
  end
  local format = vim.bo[bufnr].fileformat

  local size_bytes = vim.fn.getfsize(filepath)
  local size_str = ""
  if size_bytes >= 1048576 then
    size_str = string.format("%.2f MB", size_bytes / 1048576)
  elseif size_bytes >= 1024 then
    size_str = string.format("%.1f KB", size_bytes / 1024)
  elseif size_bytes >= 0 then
    size_str = size_bytes .. " B"
  else
    size_str = "new / unwritten"
  end
  local branch = ""
  local ok_git, head = pcall(vim.fn.systemlist, "git -C " .. vim.fn.shellescape(vim.fn.fnamemodify(filepath, ":h")) .. " branch --show-current")
  if ok_git and head and #head > 0 and head[1] ~= "" then
    branch = head[1]
  end

  local diag_err = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.ERROR })
  local diag_warn = #vim.diagnostic.get(bufnr, { severity = vim.diagnostic.severity.WARN })
  local diag_str = (diag_err == 0 and diag_warn == 0) and "Clean (0 errors)" or string.format("%d Error(s), %d Warning(s)", diag_err, diag_warn)

  local info_lines = {
    "", -- Dòng trống để đẩy Path xuống hàng riêng biệt, không bị dính vào header
    string.format("󰈚 Path:     %s", rel_path),
    string.format("󰉋 Size:     %s", size_str),
    string.format("󰌷 Type:     %s", file_type),
    string.format("󰉿 Encoding: %s (%s)", encoding, format),
  }

  if branch ~= "" then
    table.insert(info_lines, string.format(" Branch:   %s", branch))
  end
  table.insert(info_lines, string.format("󰒡 Diag:     %s", diag_str))

  vim.notify(table.concat(info_lines, "\n"), vim.log.levels.INFO, {
    title = "File Properties",
    timeout = 7000,
  })
end

vim.keymap.set("n", "<leader>bi", show_file_info, { desc = "Buffer / File Info Popup" })
vim.keymap.set("n", "<leader><leader>", "<cmd>b#<cr>", { desc = "Toggle Previous Active Buffer (Alternate)" })
vim.keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Buffer List (Telescope)" })
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

-- 🪟 WINDOW MANAGEMENT & NAVIGATION (<leader>w group)
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
