# 📑 TMUX CHEATSHEET & REFERENCE

This is a quick reference for Tmux keybindings and configuration to help you stay productive during the initial transition period.

---

## 🚀 MAIN KEYBINDING CONFIGURATION (PREFIX)

- **Prefix:** `Ctrl + a` (Replaces the default `Ctrl + b` for ergonomic comfort).
  - _Every Tmux keybinding starts by pressing this key combination first, then pressing the subsequent key._

---

## 🔍 KEYBINDING LOOKUP TECHNIQUES (WHICH-KEY EQUIVALENT)

Tmux has powerful built-in lookup tools so you never forget a keybinding:

1. **Browse all keybindings (Searchable List):**
   - Press **`Prefix`** then **`?`** (i.e., `Ctrl + a` $\rightarrow$ `?`).
   - This opens a list of all active keybindings. Use arrow keys or `j`/`k` to navigate, and press `/` to search by keyword. Press `q` to exit.
2. **View concise descriptions via CLI:**
   - Run: `tmux list-keys -N` to list all keys with short English descriptions.
3. **Generate a dynamic Which-Key lookup popup (Optional - Requires additional setup):**
   - _Requirement:_ Install fzf (`sudo pacman -S fzf`) and add the following line to `tmux.conf`:
     `bind-key Space run-shell -b "tmux list-keys -N | fzf-tmux -p 80%,60% --reverse --prompt='Tmux Keys: '"`
   - _Usage:_ Press **`Prefix`** then **`Space`** to open a fuzzy-searchable keybinding popup.

---

## 📂 PANE & WINDOW MANAGEMENT

### 1. Pane Management (Screen Splits)

- **Vertical split (Left/Right):** `Prefix` + **`|`** (the `|` key is `Shift + \`).
- **Horizontal split (Top/Bottom):** `Prefix` + **`-`** (the minus key).
- **Navigate between Panes (Vim-style - Seamless integration with Neovim):**
  - **No Prefix required!** Type directly:
  - `Ctrl` + `h` $\rightarrow$ Move to the left pane (or Neovim split left).
  - `Ctrl` + `l` $\rightarrow$ Move to the right pane (or Neovim split right).
  - `Ctrl` + `j` $\rightarrow$ Move to the pane below (or Neovim split bottom).
  - `Ctrl` + `k` $\rightarrow$ Move to the pane above (or Neovim split top).
- **Resize Panes:**
  - Press `Prefix` (`Ctrl + a`) then hold or repeatedly press uppercase **`H / J / K / L`** to resize (left/down/up/right).
  - Alternatively, use the mouse to drag pane borders directly.
- **Close current Pane:** `Prefix` + `x` (or type `exit`).
- **Zoom/Unzoom current Pane:** `Prefix` + `z` (Extremely useful for full-screen code review, then restoring the layout).

### 2. Window Management (Tabs in the Bottom Status Bar)

- **Create a new Window:** `Prefix` + `c` (Create).
- **Switch to Window N:** `Prefix` + `1`, `Prefix` + `2`, ...
- **Switch to next / previous Window:** `Prefix` + `n` / `Prefix` + `p`.
- **Rename current Window:** `Prefix` + `,`.
- **Close current Window:** `Prefix` + `&`.
- **Move Window position (Reorder Tabs):**
  - Press **`Prefix`** (`Ctrl + a`) then hold or repeatedly press **`<`** or **`>`** (i.e., `Shift + ,` and `Shift + .`) to shift the current tab left or right.
  - **Using the terminal command:** `tmux swap-window -s <old-index> -t <new-index>` (e.g., `tmux swap-window -s 3 -t 2` to move Window 3 to position 2).

---

## 💼 SESSION MANAGEMENT (PROJECTS) VIA COMMAND LINE

Each project should run in its own Session. To switch projects, detach from the current session and attach to another.

| Terminal Command                    | Function                                                                                          |
| :---------------------------------- | :------------------------------------------------------------------------------------------------ |
| `tmux new -s <name>`                | Create a new named session (e.g., `tmux new -s project-A`)                                        |
| `tmux ls`                           | List all currently running background sessions                                                    |
| `tmux a`                            | Attach to the most recently used session                                                          |
| `tmux a -t <name>`                  | Attach to a specific session by name                                                              |
| `Prefix` + `d`                      | Detach from the current session (Neovim and all processes continue running in the background)     |
| `Prefix` + `s`                      | Show an interactive session list to switch between sessions (press `x` on a session to delete it) |
| `Prefix` + `$`                      | Rename the current session                                                                        |
| `tmux rename-session -t <old> <new>` | Rename a session from the command line                                                           |
| `tmux kill-session -t <name>`       | Terminate a specific session by name                                                              |
| `tmux kill-session -a`              | Kill all other sessions (keeping only the current one)                                            |
| `tmux kill-server`                  | Shut down all sessions and the Tmux server entirely                                               |

---

## 💾 SAVE & RESTORE STATE (SESSION PERSISTENCE)

When shutting down or rebooting, you can save and restore all tabs, pane splits, and sessions:

- **Manual save:** `Prefix` + `Ctrl + s`.
- **Manual restore:** `Prefix` + `Ctrl + r`.
- _Automatic behavior:_ Continuum auto-saves every 15 minutes and auto-restores when Tmux starts.
- _Note for Neovim:_ Neovim's internal state within a pane must be saved manually with `<leader>ss` inside Neovim and restored with `<leader>sr`.