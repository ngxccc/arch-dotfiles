# tmux

> Terminal multiplexer: sessions, windows, splits, copy-mode, and keybindings.
> Tags: #tmux #terminal #multiplexer #workflow #vim
> Prefix: `Ctrl + a` (configured ergonomically in ~/.config/tmux/tmux.conf)

---

## 1. Session Management

- Start a new named session:
`tmux new -s {{session_name}}`

- List all active background sessions:
`tmux ls`

- Attach to the most recently used session:
`tmux a`

- Attach to a specific session by name:
`tmux attach -t {{session_name}}`

- Interactive session picker / switcher (press `x` on item to delete):
`Prefix + s`

- Detach from current session (keeps background processes alive):
`Prefix + d`

- Rename current session:
`Prefix + $` (or CLI: `tmux rename-session -t {{old}} {{new}}`)

- Kill a specific session:
`tmux kill-session -t {{session_name}}`

- Kill all other sessions (keep only the current active one):
`tmux kill-session -a`

- Shut down all sessions and terminate Tmux server entirely:
`tmux kill-server`

## 2. Window Management (Tabs)

- Create a new window:
`Prefix + c`

- Switch to window by index:
`Prefix + {{1..9}}`

- Rename current window:
`Prefix + ,`

- Next / Previous window:
`Prefix + n` / `Prefix + p`

- Reorder/Swap window position left or right:
`Prefix + <` / `Prefix + >` (or CLI: `tmux swap-window -s {{old}} -t {{new}}`)

- Close current window:
`Prefix + &` (or type `exit` in shell)

## 3. Pane Management (Splits)

- Split pane vertically (Left / Right):
`Prefix + |`

- Split pane horizontally (Top / Bottom):
`Prefix + -`

- Navigate between panes (Vim-style via vim-tmux-navigator - No prefix needed):
`Ctrl + h` (Left) | `Ctrl + j` (Down) | `Ctrl + k` (Up) | `Ctrl + l` (Right)

- Toggle zoom / full-screen for active pane:
`Prefix + z`

- Resize active pane (5 cells at a time, hold to repeat):
`Prefix + H` / `Prefix + J` / `Prefix + K` / `Prefix + L` (or drag borders with mouse)

- Close active pane:
`Prefix + x` (or type `exit`)

## 4. Copy Mode & Buffer (Vi Mode)

- Enter copy mode (scrollback navigation):
`Prefix + v` (or scroll with mouse wheel)

- Begin text selection (in copy mode):
`v` (char) / `V` (line) / `Ctrl + v` (block)

- Copy selection to system clipboard (Wayland wl-copy):
`y` (or release mouse drag)

- Paste buffer into current terminal:
`Prefix + p`

## 5. Configuration, Discovery & State Persistence

- Reload tmux configuration file:
`Prefix + r`

- Searchable keybindings list:
`Prefix + ?` (navigate with `j`/`k`, search with `/`, exit with `q`)

- View concise descriptions via CLI:
`tmux list-keys -N`

- Install/Update TPM plugins:
`Prefix + I` (Install) / `Prefix + U` (Update)

- Manual session save / restore (tmux-resurrect):
`Prefix + Ctrl + s` (Save) / `Prefix + Ctrl + r` (Restore)

- Note: Continuum auto-saves every 15m; inside Neovim use `<leader>ss` / `<leader>sr` for internal buffer state.

---

## Quick Keys Reference

| Key Combination | Action |
| :--- | :--- |
| `Ctrl + a` | Ergonomic Command Prefix |
| `Prefix + \|` | Vertical Split (Left/Right) |
| `Prefix + -` | Horizontal Split (Top/Bottom) |
| `Ctrl + h/j/k/l` | Seamless Pane & Neovim Navigation (No Prefix) |
| `Prefix + z` | Zoom / Maximize Active Pane |
| `Prefix + s` | Interactive Session Switcher |
| `Prefix + c` | New Window (Tab) |
| `Prefix + v` | Enter Vi Copy Mode |
| `Prefix + < / >` | Swap Window Position Left / Right |
| `Prefix + r` | Reload `~/.config/tmux/tmux.conf` |
| `Prefix + Ctrl + s / r` | Save / Restore All Sessions Across Reboots |
