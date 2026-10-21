# Yazi Cheatsheet

> Blazing fast terminal file manager (Rust, async I/O, Vim keybindings, image previews).
> Tags: #yazi #filemanager #terminal #cli #vim #workflow

---

## 1. Custom & Integration Keybinds (Custom Config)

- Open current folder in Thunar:
`O` (`Shift + o`)

- Open hovered folder/file in Thunar:
`g T`

- Jump to Workspace (`~/workspace`):
`g w`

- Jump to Storage (`~/storage`):
`g s`

- Jump to Downloads (`~/Downloads`):
`g d`

---

## 2. Navigation & Movement (Vim Style)

- Move cursor down / up:
`j` / `k` (or `Arrow Down` / `Arrow Up`)

- Enter directory / open file:
`l` or `Enter` (or `Arrow Right`)

- Leave directory (parent folder):
`h` (or `Arrow Left`)

- Jump to top / bottom of current list:
`g g` / `G`

- Scroll down / up half-page:
`Ctrl + d` / `Ctrl + u`

- Scroll down / up full-page:
`Ctrl + f` / `Ctrl + b`

- Jump to position via Zoxide (Fuzzy directory jump):
`z {{query}}`

- Default Goto menu:
`g` (shows popup: `g h` Home, `g c` Config, `g d` Downloads, `g t` Trash)

---

## 3. Selection & Visual Mode

- Toggle select current file and move down:
`Space`

- Visual selection mode (select range by moving `j`/`k`):
`v`

- Select all files in current folder:
`Ctrl + a`

- Invert current selection:
`Ctrl + r`

- Cancel / clear all selections:
`Escape`

---

## 4. File Operations (Create, Copy, Cut, Paste, Delete)

- Create new file or folder (end with `/` to create folder):
`a`

- Rename hovered file:
`r`

- Rename hovered file without extension:
`R`

- Yank (Copy) selected / hovered files:
`y`

- Cut (Move) selected / hovered files:
`x`

- Paste yanked / cut files:
`p`

- Paste and overwrite if file exists:
`P`

- Delete to Trash:
`d`

- Permanently delete (Bypass Trash - use with caution):
`D`

---

## 5. Finding, Filtering & Searching

- Search files recursively via Ripgrep:
`s`

- Fuzzy find in current directory (fd / fzf):
`Z`

- Filter current file list as you type:
`f`

- Find next / previous match (Vim style):
`/ {{pattern}}` -> `n` (next) / `N` (prev)

---

## 6. View, Preview & Tabs

- Toggle hidden files:
`.` (dot)

- Open Tab:
`t`

- Close current Tab:
`w`

- Switch between Tabs:
`1` .. `9` or `[` / `]`

- View tasks / background jobs:
`w`

- Toggle full preview mode:
`T`

---

## 7. Shell & Execution

- Open interactive shell command prompt:
`;`

- Open block shell command (waits for process):
`:`

- Copy absolute file path to clipboard:
`c c`

- Copy file name to clipboard:
`c n`

- Copy directory path to clipboard:
`c d`

---

## 8. Quick Reference Table

| Keybinding | Action |
|---|---|
| `O` | Open current directory in **Thunar** |
| `g T` | Open hovered folder/file in **Thunar** |
| `g w` / `g s` / `g d` | Quick jump: Workspace / Storage / Downloads |
| `z <name>` | Zoxide interactive jump |
| `h` / `j` / `k` / `l` | Left / Down / Up / Right (Enter) |
| `Space` / `v` | Select item / Visual range select |
| `a` / `r` / `d` / `D` | Create / Rename / Trash / Hard Delete |
| `y` / `x` / `p` | Copy / Cut / Paste |
| `.` | Toggle hidden files |
| `q` | Quit Yazi |
| `~` or `F1` | Show official internal Help & Keybinds |
