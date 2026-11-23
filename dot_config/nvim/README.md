# 🚀 Neovim Configuration & Keymaps

Cấu hình Neovim native-first: buffer là dữ liệu, tabpage là workspace, không dùng bufferline.
`<leader>` = **Space**, `<localleader>` = `,`.

---

## 🔍 How to Find & Export Keymaps

1. **Interactive Search**: `<leader>fk` (hoặc `:Telescope keymaps`) — tra toàn bộ keymap đang active, gồm cả buffer-local.
2. **Auto-Export**: chạy `:ExportKeymaps` để regenerate **[KEYMAPS_AUTOGEN.md](./KEYMAPS_AUTOGEN.md)**.
   - Quét mode Normal / Visual / Operator / Insert / Terminal.
   - Key LSP buffer-local lấy từ `lua/config/lsp_keymaps.lua` (SSOT dùng chung với `LspAttach`).
   - Key nội bộ của blink.cmp không nằm trong `nvim_get_keymap()`, được ghi chú riêng trong file export.

---

## 📦 Plugin Ecosystem

### 🛠️ 1. LSP, Formatting & Linting (`lua/plugins/lsp/`)

- **`nvim-lspconfig` + `mason.nvim`**: Native LSP (`vim.lsp.config`/`vim.lsp.enable`) cho Lua, Python, TS/JS, Go, Rust, HTML/CSS/JSON, Tailwind, Prisma, SQL.
  - Mason được lazy-load qua `cmd`, nên `:Mason` / `:MasonInstall` / `:MasonLog` / `:MasonToolsInstall` luôn dùng được ngay từ buffer đầu tiên (trước đây lỗi `E492: Not an editor command: Mason`). Mở nhanh bằng `<leader>cm`.
- **`blink.cmp`**: Completion engine (LSP + snippets + path + buffer). `<Tab>` accept gợi ý / nhảy snippet placeholder, `<C-j>`/`<C-k>` chọn item, `<CR>` accept item đang chọn.
- **`conform.nvim`**: Format on save, có condition theo config repo (`oxfmt` → `biome` → `prettier`; `stylua`, `ruff_format`, `goimports`+`gofumpt`, `rumdl`, `taplo`, `sql_formatter`).
- **`nvim-lint`**: Lint on save (`selene` cho Lua, `shellcheck` cho Shell, `hadolint` cho Dockerfile, `rumdl` cho Markdown, `yamllint` cho YAML, `oxlint` khi repo có `.oxlintrc.json`, `golangci-lint` cho Go) + **`actionlint`** cho riêng `.github/workflows/*.yml|yaml`. Python dùng pyright + ruff LSP; mypy để CI.
- **`rustaceanvim` + `crates.nvim`**: Rust IDE (clippy on save, DAP codelldb, runnables/testables) và quản lý dependency Cargo.toml.
- **`nvim-dap` + `nvim-dap-ui` + virtual text**: Debug Go/Rust, breakpoint, REPL, evaluate.

### 🌳 2. Syntax & Editing (`lua/plugins/editor/`)

- **`nvim-treesitter` + textobjects**: Highlight/indent/fold, di chuyển `]f` `[f` `]c` `[c`, select `af` `if` `ac` `ic`.
- **`nvim-ufo`**: Folding với virtual text; tự tắt trên file lớn.
- **`nvim-autopairs`**: Auto-close cặp ngoặc/quote, có FastWrap `<M-e>`.
- **`grug-far.nvim`**: Search & replace toàn workspace (`<leader>sr`). Có sẵn 3 engine: `ripgrep` (mặc định), **`astgrep`** và **`astgrep-rules`** — mở structural search bằng `<leader>sA`, hoặc bấm `,e` trong panel để đổi engine.
- **`render-markdown.nvim` + `markdown-preview.nvim`**: Render trong Neovim và preview trình duyệt (`<leader>mp`).
- **`vim-doge`**, **`undotree`**, **`nvim-highlight-colors`**: doc generator, undo tree, highlight mã màu.

### 🧭 3. Navigation & Terminal (`lua/plugins/navigation/`)

- **`oil.nvim`**: Sửa filesystem như buffer. `-` mở parent, `<leader>e` float, `<leader>E` fullscreen. Copy path: `y.` (register hiện tại), `yp` (relative), `ya` (absolute), `yn` (tên file).
- **`telescope.nvim`**: Finder (`<leader>ff`, `<leader>fw`, `<leader>fb`, `<leader>fk`, `<leader>fg`…).
- **`harpoon`**: Bookmark file (`<leader>ha`, `<leader>1`–`<leader>4`, `<C-e>` mở menu).
- **`toggleterm.nvim`**: Terminal (`<C-t>`, Esc Esc để thoát terminal-mode).
- **`vim-tmux-navigator`**: Di chuyển split/tmux pane bằng `<C-h/j/k/l>`.

### 🎨 4. UI (`lua/plugins/ui/`)

- **`catppuccin`** (mocha), **`mini.icons`** (mock devicons), **`lualine.nvim`**, **`which-key.nvim`**, **`noice.nvim`**, **`dressing.nvim`**, **`fidget.nvim`**, **`indent-blankline.nvim`**, **`tiny-inline-diagnostic.nvim`**, **`trouble.nvim`**, **`todo-comments.nvim`**, **`zen-mode.nvim`**, **`ts-error-translator.nvim`**.
- **Không có bufferline**: dùng tabpage làm workspace, tên tab qua `:TabRename <name>`.

### 🐙 5. Git (`lua/plugins/git/`)

- **`neogit`** (`<leader>gg`), **`diffview.nvim`** (`<leader>gd`/`<leader>gD`), **`gitsigns.nvim`** (blame inline, stage buffer `<leader>ga`), **`vim-fugitive`** (`:Git`, `:G`).

---

## ⚡ Performance Invariants

- Cold/warm startup mục tiêu ≤ 40ms (đo bằng `nvim --startuptime`).
- Plugin lazy theo `event`/`cmd`/`keys`; eager chỉ giữ `catppuccin`, `mini.icons`, `lualine`, `oil`.
- **Big-file guard** (> 500KB hoặc > 5000 dòng): tắt Treesitter, folding (UFO), autopairs, format-on-save, lint-on-save, LSP attach; tắt `indentexpr` và `autoindent`.
- `nvim-lint` chỉ chạy `BufWritePost`; `conform` chạy on save và bỏ qua file lớn.
