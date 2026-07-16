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

-- clipboard (Explicitly use wl-clipboard on Wayland or xclip/xsel on X11 to prevent tmux/OSC 52 clipboard-read prompts)
local has_wayland = vim.env.WAYLAND_DISPLAY ~= nil and vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1
local has_x11 = vim.env.DISPLAY ~= nil and (vim.fn.executable("xclip") == 1 or vim.fn.executable("xsel") == 1)

if has_wayland then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy",
      ["*"] = "wl-copy",
    },
    paste = {
      ["+"] = "wl-paste --no-newline",
      ["*"] = "wl-paste --no-newline",
    },
    cache_enabled = 1,
  }
  set.clipboard:append("unnamedplus")
elseif has_x11 then
  if vim.fn.executable("xclip") == 1 then
    vim.g.clipboard = {
      name = "xclip",
      copy = {
        ["+"] = "xclip -quiet -i -selection clipboard",
        ["*"] = "xclip -quiet -i -selection primary",
      },
      paste = {
        ["+"] = "xclip -o -selection clipboard",
        ["*"] = "xclip -o -selection primary",
      },
      cache_enabled = 1,
    }
  else
    vim.g.clipboard = {
      name = "xsel",
      copy = {
        ["+"] = "xsel --nodetach -i -b",
        ["*"] = "xsel --nodetach -i -p",
      },
      paste = {
        ["+"] = "xsel -o -b",
        ["*"] = "xsel -o -p",
      },
      cache_enabled = 1,
    }
  end
  set.clipboard:append("unnamedplus")
else
  -- No working system clipboard detected/active (e.g. stale tmux pane without WAYLAND_DISPLAY).
  -- We do NOT enable unnamedplus to prevent Neovim from falling back to tmux/OSC 52, which
  -- triggers Kitty security prompts and garbage character input.
  set.clipboard = ""
end

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
