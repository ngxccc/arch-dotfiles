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

-- Sync environment variables from active tmux session to prevent stale X11/Wayland variables
local function sync_tmux_env()
  if not vim.env.TMUX then return end
  local output = vim.fn.system("tmux show-environment")
  if vim.v.shell_error == 0 then
    local targets = {
      DISPLAY = true,
      WAYLAND_DISPLAY = true,
      XAUTHORITY = true,
      SSH_AUTH_SOCK = true,
    }
    for line in string.gmatch(output, "[^\r\n]+") do
      if not line:match("^%-") then
        local key, val = line:match("^([^=]+)=(.*)$")
        if key and targets[key] then
          vim.env[key] = val
        end
      end
    end
  end
end

-- Clipboard setup based on current environment (using system tools rather than OSC 52 to avoid prompts)
local function configure_clipboard()
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
    set.clipboard = "unnamedplus"
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
    set.clipboard = "unnamedplus"
  else
    -- No working system clipboard detected/active (e.g. stale tmux pane without WAYLAND_DISPLAY).
    -- We do NOT enable unnamedplus to prevent Neovim from falling back to tmux/OSC 52, which
    -- triggers Kitty security prompts and garbage character input.
    set.clipboard = ""
  end
end

-- Defer sync tmux environment and clipboard configuration to VimEnter/FocusGained (removes startup I/O blocking)

-- Autocmd to update environment and reconfigure clipboard when Neovim gains focus
vim.api.nvim_create_autocmd({ "FocusGained", "VimEnter" }, {
  desc = "Sync tmux environment variables and configure clipboard",
  callback = function()
    sync_tmux_env()
    configure_clipboard()
  end,
})

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

-- Clean window title formatting
function _G.get_clean_title()
  local bufname = vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return "[No Name] - Neovim"
  end
  if bufname:match("^oil://") then
    local path = bufname:gsub("^oil://", "")
    return vim.fn.fnamemodify(path, ":p:~") .. " - Neovim"
  end
  local file = vim.fn.fnamemodify(bufname, ":t")
  local mod = vim.bo.modified and " [+]" or ""
  return file .. mod .. " - Neovim"
end
set.title = true
set.titlestring = "%{v:lua.get_clean_title()}"

-- Clean tabline formatting (supports custom :TabRename and automatic file/folder fallback)
vim.api.nvim_create_user_command("TabRename", function(opts)
  vim.t.tab_title = opts.args
  vim.cmd("redrawtabline")
end, { nargs = 1, desc = "Rename current tab workspace" })

function _G.get_tabline()
  local s = ""
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr("$")

  for i = 1, total_tabs do
    local tab_hl = (i == current_tab) and "%#TabLineSel#" or "%#TabLine#"
    s = s .. "%" .. i .. "T" .. tab_hl .. " " .. i .. " "

    local winnr = vim.fn.tabpagewinnr(i)
    local buflist = vim.fn.tabpagebuflist(i)
    local bufnr = buflist[winnr]
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    local custom_title = vim.t[i].tab_title
    local title = "[No Name]"
    if custom_title and custom_title ~= "" then
      title = "󰓩 " .. custom_title
    elseif bufname:match("^oil://") then
      local path = bufname:gsub("^oil://", ""):gsub("/$", "")
      title = " " .. vim.fn.fnamemodify(path, ":t")
    elseif bufname ~= "" then
      title = vim.fn.fnamemodify(bufname, ":t")
    end

    local mod = ""
    for _, b in ipairs(buflist) do
      if vim.api.nvim_get_option_value("modified", { buf = b }) then
        mod = " "
        break
      end
    end

    s = s .. title .. mod .. " "
  end

  s = s .. "%#TabLineFill#%T"
  return s
end
set.tabline = "%!v:lua.get_tabline()"

-- Hide command-line area at the bottom when not in use
set.cmdheight = 0
-- Disable word wrap by default for code performance (toggle when needed)
set.wrap = false
set.linebreak = false
set.breakindent = false

-- Filetype mapping for ASP.NET / Blazor Razor files
vim.filetype.add({
  extension = {
    cshtml = "razor",
    razor = "razor",
  },
})

-- Disable verbose LSP file logging to improve performance and clear checkhealth warning
vim.lsp.log.set_level("OFF")
