-- OPTIONS
local set = vim.opt

set.modeline = false
set.mouse = "a"

--line nums
set.relativenumber = true
set.number = true

-- indentation and tabs
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.autoindent = true
set.expandtab = true

-- search settings
set.ignorecase = true
set.smartcase = true

-- appearance
set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"

-- cursor line
set.cursorline = true
-- set.colorline = "80"

-- clipboard
set.clipboard:append("unnamedplus")

-- backspace
set.backspace = "indent,eol,start"

-- split windows
set.splitbelow = true
set.splitright = true

-- dw/diw/ciw works on full-word
set.iskeyword:append("-")

-- keep cursor at least 8 rows from top/bot
set.scrolloff = 8

-- undo dir settings
set.swapfile = false
-- backup
set.backup = false
set.undodir = vim.fn.stdpath("data") .. "/undo"
set.undofile = true

-- incremental search
set.incsearch = true

-- faster cursor hold
set.updatetime = 250
-- Add Mason's installation directory to Neovim's PATH so other plugins (like nvim-lint) can find the tools
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
end

-- Enable terminal window title updates
set.title = true
-- Hide command-line area at the bottom when not in use
set.cmdheight = 0

-- Word wrap configurations (for long classes and HTML)
set.wrap = true
set.linebreak = true
set.breakindent = true
