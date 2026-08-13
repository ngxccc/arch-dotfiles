# 🚀 Neovim Configuration & Keymaps

Welcome to your modern, feature-packed Neovim setup! The `<leader>` key defaults to **Space**.

---

## 🔍 How to Find & Export Keymaps

1. **Interactive Search (`Space` + `f` + `k`)**:
   Press `<leader>fk` (or run `:Telescope keymaps`) to open an interactive search window for all active shortcuts.

2. **Auto-Export to Markdown (`:ExportKeymaps`)**:
   Run `:ExportKeymaps` inside Neovim anytime you add or update keymaps. It will automatically scan the active system and regenerate **[KEYMAPS_AUTOGEN.md](./KEYMAPS_AUTOGEN.md)**.

---

## 📦 Plugin Ecosystem & Integrated Tools

### 🛠️ 1. LSP, Formatting & Linting (`lua/plugins/lsp/`)

- **`nvim-lspconfig` & `mason.nvim`**: Native LSP client and automatic installer/manager for 30+ language servers (Go, TypeScript/JavaScript, Python, TailwindCSS, Lua, HTML, CSS, JSON, etc.).
- **`conform.nvim`**: Asynchronous code formatter supporting `prettier`, `gofmt`, `stylua`, `blade-formatter`, with automatic format-on-save.
- **`nvim-lint`**: Fast asynchronous linter integration for external tools (`golangci-lint`, `eslint_d`, `shellcheck`).
- **`nvim-cmp`**: Ultra-fast autocomplete engine powered by LSP sources, snippets (`LuaSnip`), buffer words, and file paths.
- **`nvim-lsp-file-operations`**: Automatically updates imports when renaming or moving files/folders in Neo-tree.

### 🌳 2. Syntax & Editing Enhancements (`lua/plugins/editor/`)

- **`nvim-treesitter` & `textobjects`**: AST-based syntax highlighting, indentation, folding, and structural navigation (`]f`/`[f` for functions, `]c`/`[c` for classes).
- **`vim-visual-multi`**: VS Code style multi-cursor editing (`Ctrl+n`, `Ctrl+Alt+j`, `Ctrl+Alt+k`).
- **`nvim-ufo`**: Modern, fast code folding with fold count preview (`zM` to close all, `zR` to open all).
- **`grug-far.nvim`**: Interactive global search and replace tool across the entire workspace (`<leader>sr`).
- **`markdown-preview.nvim`**: Live Markdown browser preview (`<leader>mp`).
- **`nvim-autopairs`**: Auto-closes brackets, parenthesis, quotes, and HTML tags.
- **`tree-sitter-blade`**: Laravel Blade template syntax highlighting support.
- **`orgmode`**: Emacs-style Org-mode for task tracking and structured notes in Neovim.

### 🧭 3. Navigation & Terminal (`lua/plugins/navigation/`)

- **`neo-tree.nvim`**: Feature-rich file explorer with git status indicators and file manipulation (`<leader>e`).
- **`oil.nvim`**: File manager that lets you edit directory structures like a text buffer (`<leader>cd` or `-`).
- **`telescope.nvim`**: Highly extensible fuzzy finder for files, text grep, keymaps, buffers, and diagnostics (`<leader>ff`, `<leader>fw`, `<leader>fk`).
- **`harpoon`**: Fast file bookmarking tool to jump instantly between hot files (`<leader>ha`, `<C-e>`).
- **`toggleterm.nvim`**: Integrated floating and split terminal manager (`<C-t>`).
- **`vim-tmux-navigator`**: Seamless window navigation between Neovim splits and Tmux panes using `<C-h/j/k/l>`.

### 🎨 4. User Interface & Aesthetics (`lua/plugins/ui/`)

- **`catppuccin`**: Premium color scheme with integrations across all UI components.
- **`lualine.nvim`**: Fast status line showing current mode, git branch, diagnostics, and LSP status.
- **`bufferline.nvim`**: VS Code style top tab bar displaying open buffers (`<leader>be`, `<M-h>`, `<M-l>`).
- **`which-key.nvim`**: Popup keymap helper displaying available shortcuts as you type (`<leader>`).
- **`noice.nvim`**: Modern UI replacement for messages, cmdline, and popupmenu using `nui.nvim`.
- **`trouble.nvim`**: Beautiful list for diagnostics, references, quickfix, and location lists (`<leader>xx`, `<leader>cs`).
- **`todo-comments.nvim`**: Highlights and searches TODO, FIXME, BUG notes in code (`<leader>ft`).
- **`zen-mode.nvim`**: Distraction-free coding mode (`<leader>z`).
- **`fidget.nvim`**: Standalone LSP progress notifications in the bottom-right corner.
- **`indent-blankline.nvim`**: Visual indent guide lines with active scope context highlighting.
- **`dressing.nvim`**: Enhances Neovim's default `vim.ui.select` and `vim.ui.input` interfaces with Telescope/floating windows.

### 🐙 5. Git Integration (`lua/plugins/git/`)

- **`neogit`**: Magit-style Git interface inside Neovim (`<leader>gn`).
- **`diffview.nvim`**: Side-by-side Git diff viewer and merge conflict resolver (`<leader>gd`).
- **`gitsigns.nvim`**: Inline git status, gutter signs, stage/hunk previews, and blame lines.
