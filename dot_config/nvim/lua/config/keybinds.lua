-- KEYBINDS
vim.g.mapleader = " "
vim.g.maplocalleader = ","
-- 📂 FILE & EXPLORER
vim.keymap.set(
  "n",
  "<leader>cd",
  "<cmd>Oil<cr>",
  { desc = "Open Oil (File Explorer)" }
)
vim.keymap.set("n", "<leader><leader>", function()
  -- Get the filetype of the current window
  local ft = vim.bo.filetype

  -- Only allow the source command if it is actually a config file (Lua or Vimscript)
  if ft == "lua" or ft == "vim" then
    vim.cmd("source %") -- % represents the current file path
    vim.notify(
      "🚀 Config reloaded: " .. vim.fn.expand("%:t"),
      vim.log.levels.INFO
    )
  else
    -- Warn if triggered on a non-config file (e.g., Neo-tree, PHP, JS)
    vim.notify(
      "⚠️ Cannot source: current filetype is '"
        .. ft
        .. "'. Source is only supported for Lua or Vimscript files.",
      vim.log.levels.WARN
    )
  end
end, { desc = "Source current file safely" })
vim.keymap.set(
  "n",
  "<leader>rl",
  "<cmd>source ~/.config/nvim/init.lua<cr>",
  { desc = "Reload Neovim Config" }
)
vim.keymap.set(
  "n",
  "<leader>mx",
  "<cmd>!chmod +x %<CR>",
  { silent = true, desc = "Make current file executable (mx)" }
)

-- 🚀 MOVEMENT & EDITING
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "Select entire file" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent and keep selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Outdent and keep selection" })
vim.keymap.set("v", "H", "^", { desc = "Move to start of line" })
vim.keymap.set("v", "L", "$h", { desc = "Move to end of line" })
vim.keymap.set(
  "n",
  "J",
  "mzJ`z",
  { desc = "Join lines and keep cursor position" }
)
vim.keymap.set("n", "H", "^", { desc = "Move to start of line" })
vim.keymap.set("n", "L", "$", { desc = "Move to end of line" })
vim.keymap.set(
  "n",
  "<C-d>",
  "<C-d>zz",
  { desc = "Scroll half page down (centered)" }
)
vim.keymap.set(
  "n",
  "<C-u>",
  "<C-u>zz",
  { desc = "Scroll half page up (centered)" }
)
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev search result (centered)" })
vim.keymap.set(
  "n",
  "<leader>nh",
  ":nohlsearch<CR>",
  { silent = true, desc = "Clear search highlights" }
)
vim.keymap.set("n", "<leader>o", "o<Esc>", { desc = "Open line below" })
vim.keymap.set("n", "<leader>O", "O<Esc>", { desc = "Open line above" })

-- 🛡️ CLIPBOARD & REGISTERS (Preserve clipboard across operations)
vim.keymap.set(
  "x",
  "<leader>p",
  [["_dP]],
  { desc = "Paste without overwriting register" }
)
vim.keymap.set("n", "<leader>dl", "dd", { desc = "Delete current line (dl)" })
vim.keymap.set(
  { "n", "v" },
  "<leader>D",
  [[_d]],
  { desc = "Delete to blackhole register (keep clipboard)" }
)

vim.keymap.set(
  "i",
  "<C-c>",
  "<Esc>",
  { desc = "Escape insert mode properly (Ctrl+C act as Esc)" }
)

-- 💾 SAVE & QUIT
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set({ "n", "i", "v" }, "<C-q>", "<cmd>q<CR>", { desc = "Quit vim" })
vim.keymap.set("n", "Q", "<nop>", { desc = "Disable annoying Ex mode" })

-- 🗃️ SESSION MANAGEMENT (Save/Restore open files, tabs, splits)
vim.keymap.set("n", "<leader>Ss", function()
  vim.cmd("Neotree close")
  vim.cmd("mksession! ~/.local/share/nvim/last_session.vim")
  vim.notify("Global session saved successfully", vim.log.levels.INFO)
end, { desc = "Save Global Session" })

vim.keymap.set("n", "<leader>Sr", function()
  vim.cmd("source ~/.local/share/nvim/last_session.vim")
  vim.notify("Global session restored successfully", vim.log.levels.INFO)
end, { desc = "Restore Global Session" })

-- 📋 QUICKFIX & LOCATION LIST (Essential for navigating logs and diagnostics)
vim.keymap.set(
  "n",
  "<leader>cl",
  ":cclose<CR>",
  { silent = true, desc = "Close Quickfix list" }
)
vim.keymap.set(
  "n",
  "<leader>co",
  ":copen<CR>",
  { silent = true, desc = "Open Quickfix list" }
)
vim.keymap.set(
  "n",
  "<leader>cn",
  ":cnext<CR>zz",
  { desc = "Next Quickfix item" }
)
vim.keymap.set(
  "n",
  "<leader>cp",
  ":cprev<CR>zz",
  { desc = "Prev Quickfix item" }
)

vim.keymap.set(
  "n",
  "<leader>k",
  "<cmd>lnext<CR>zz",
  { desc = "Next Location list item" }
)
vim.keymap.set(
  "n",
  "<leader>j",
  "<cmd>lprev<CR>zz",
  { desc = "Prev Location list item" }
)

-- 🛠️ TOOLS & PLUGINS
vim.keymap.set(
  "n",
  "<leader>dg",
  "<cmd>DogeGenerate<cr>",
  { desc = "Generate Docblocks (vim-doge)" }
)
vim.keymap.set(
  "n",
  "<leader>cc",
  "<cmd>!php-cs-fixer fix % --using-cache=no<cr>",
  { desc = "Lint/Format PHP file" }
)
vim.keymap.set(
  "n",
  "<leader>li",
  ":checkhealth vim.lsp<CR>",
  { desc = "LSP Info Healthcheck" }
)
vim.keymap.set(
  "n",
  "<leader>u",
  vim.cmd.UndotreeToggle,
  { desc = "Toggle UndoTree" }
)
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
  vim.cmd("bd " .. bufnr)
end, { desc = "Close current buffer" })


-- 🔍 SEARCH & REPLACE
-- Note: The :s/... command only replaces on the *current line*. Use :%s/... to replace across the entire file.
vim.keymap.set(
  "n",
  "<leader>ss",
  [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
  { desc = "Replace word under cursor (Current File)" }
)

-- Window Navigation
vim.keymap.set(
  "n",
  "<C-Up>",
  "<cmd>resize +2<cr>",
  { desc = "Increase Window Height" }
)
vim.keymap.set(
  "n",
  "<C-Down>",
  "<cmd>resize -2<cr>",
  { desc = "Decrease Window Height" }
)
vim.keymap.set(
  "n",
  "<C-Left>",
  "<cmd>vertical resize -2<cr>",
  { desc = "Decrease Window Width" }
)
vim.keymap.set(
  "n",
  "<C-Right>",
  "<cmd>vertical resize +2<cr>",
  { desc = "Increase Window Width" }
)
vim.keymap.set(
  "n",
  "<Tab>",
  "<C-w>w",
  { desc = "Cycle through windows", silent = true }
)


vim.keymap.set(
  "n",
  "gl",
  vim.diagnostic.open_float,
  { desc = "Show Line Diagnostics" }
)

vim.keymap.set(
  "n",
  "[d",
  vim.diagnostic.goto_prev,
  { desc = "Go to Previous Diagnostic" }
)

vim.keymap.set(
  "n",
  "]d",
  vim.diagnostic.goto_next,
  { desc = "Go to Next Diagnostic" }
)

vim.keymap.set(
  "n",
  "<leader>cy",
  function()
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
  end,
  { desc = "Copy Line Diagnostics to Clipboard" }
)

vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set(
  "i",
  "<A-j>",
  "<esc><cmd>m .+1<cr>==gi",
  { desc = "Move line down" }
)
vim.keymap.set(
  "i",
  "<A-k>",
  "<esc><cmd>m .-2<cr>==gi",
  { desc = "Move line up" }
)

vim.keymap.set("n", "<A-J>", "yyp", { desc = "Duplicate line down" })
vim.keymap.set("n", "<A-K>", "yyP", { desc = "Duplicate line up" })
vim.keymap.set("v", "<A-J>", "Y'>p", { desc = "Duplicate block down" })
vim.keymap.set("v", "<A-K>", "Y'<P", { desc = "Duplicate block up" })

vim.keymap.set(
  "n",
  "<leader>ga",
  function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if ok then
      gitsigns.stage_buffer()
      vim.notify("Staged current buffer successfully")
    else
      vim.notify("Gitsigns not loaded", vim.log.levels.ERROR)
    end
  end,
  { desc = "Git stage (add) current file" }
)