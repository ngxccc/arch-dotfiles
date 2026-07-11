# 🚀 Neovim Comprehensive Keymaps Cheatsheet

This guide lists in detail **all configured keymaps and features** in your Neovim setup. The `<leader>` key defaults to the **Space** key.

---

## 🔍 Look Up Keymaps Directly (`<leader>fk`)
If you forget a keymap, press:
*   **`Space` + `f` + `k`** to open the interactive keymap search tool via Telescope. Simply type the feature you need (e.g., `rename`, `git`, `find`...) to see the corresponding keymaps.

---

## 📂 1. File & Directory Management (File Explorer)

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`Space` + `e`** | Toggle Neo-tree | Displays the directory tree on the left side. Shows hidden files by default (`visible = true`). |
| **`Y`** (inside Neo-tree) | Copy Absolute Path | Copy the absolute system path of the current file/directory under the cursor to the clipboard. |
| **`g` + `y`** (inside Neo-tree) | Copy Relative Path | Copy the relative path (from workspace root) of the current file/directory to the clipboard. |
| **`-` (Minus)** | Open Oil.nvim | Edit files/directories as a text buffer. Create, rename, and delete files just like editing text, then type `:w` to save. |
| **`Space` + `ha`** | Harpoon: Add File | Quickly save the current file to the Harpoon bookmark list. |
| **`Ctrl` + `e`** | Harpoon: Quick Menu | Display the window listing all files bookmarked by Harpoon. |
| **`Space` + `fl`** | Harpoon: Telescope | Filter and quickly search the Harpoon file list via the Telescope interface. |
| **`Ctrl` + `p`** | Harpoon: Previous File | Jump quickly to the previous bookmarked file in the Harpoon list. |
| **`Ctrl` + `n`** | Harpoon: Next File | Jump quickly to the next bookmarked file in the Harpoon list. |
| **`Space` + `bd`** | Close Buffer | Close the current file (buffer) while keeping the split window layout intact. |
| **`Space` + `c` + `d`** | Open Netrw (Explorer) | Open Vim's default file manager, Netrw. |

> 💡 **Auto Import Fix:** When you rename or move a file directly in **Neo-tree**, the system will automatically scan the project via LSP and update all affected `import` paths in other files (similar to VS Code).

---

## 🔍 2. Fuzzy Finder (Telescope)

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`Space` + `f` + `f`** | Find File | Quickly find a file by name in the current project. |
| **`Space` + `f` + `a`** | Find All Files | Find files including hidden ones (e.g., `.env`, `.gitignore`...). |
| **`Space` + `f` + `w`** | Live Grep | Search for any word or phrase within the contents of all files in the workspace. |
| **`Space` + `f` + `g`** | Manual Search | Open an input prompt to search for a keyword across all files in the project. |
| **`Space` + `f` + `s`** | Find Word Under Cursor | Use the word under the cursor to search for all its occurrences across the project. |
| **`Space` + `f` + `c`** | Find Current Filename | Find all locations in the project that reference or use the current filename. |
| **`Space` + `f` + `i`** | Find Nvim Config Files | Quickly search files within the `~/.config/nvim/` configuration directory. |
| **`Space` + `f` + `o`** | Recent Files | View a list of the most recently edited files. |
| **`Space` + `f` + `b`** | Manage Buffers | View a list of all open files (buffers) for quick navigation. |
| **`Space` + `f` + `t`** | Search Notes | Automatically list all TODO, FIXME, and similar notes present in the project. |
| **`Space` + `f` + `q`** | Search Quickfix List | View and search within the Quickfix list. |
| **`Space` + `f` + `h`** | Search Help Tags | Search Neovim documentation and help tags. |
| **`Space` + `f` + `k`** | Find Keymaps | List and search all active keymaps in the system. |
| **`Space` + `r` + `l`** | Reload Neovim Config | Restart Neovim and reload all configuration files. |
| **`Space` + `Space`** | Source Current File | Safely reload the configuration of only the currently open file. |
| **`Space` + `s` + `r`** | Global Search & Replace | Open GrugFar to interactively search and replace text across the entire project (VS Code style). |

---

## 💻 3. Editor & LSP (Code Intelligence)

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`g` + `d`** | Go to Definition | Jump directly to the definition of the function, variable, or class under the cursor. |
| **`K`** | Hover Documentation | Show a detailed documentation popup (types, description) for the function/variable under the cursor. |
| **`g` + `r`** | Show References | Find all locations using this function/variable across the project via Telescope. |
| **`g` + `i`** | Go to Implementation | Find the implementation location of a function, variable, or interface. |
| **`Space` + `r` + `n`** | Rename Symbol | Rename a variable/function and **automatically update it across all related files** (like `F2` in VS Code). |
| **`Space` + `c` + `a`** | Code Actions | View LSP quick-fix suggestions, auto-imports, etc., for the current line of code. |
| **`g` + `l`** | Line Diagnostics | Display detailed error/warning messages for the current line as a popup. |
| **`[` + `d`** | Previous Error/Warning | Jump to the previous diagnostic error or warning in the active file. |
| **`]` + `d`** | Next Error/Warning | Jump to the next diagnostic error or warning in the active file. |
| **`Space` + `c` + `y`** | Copy Error Message | Extract and copy all error/warning messages on the current line to the system clipboard. |
| **`Space` + `l` + `i`** | LSP Healthcheck | Check the status of all currently connected LSP servers. |
| **`Space` + `d` + `g`** | Generate Docblock (Doge) | Automatically generate a documentation comment block (docstring) for a function/class using vim-doge. |

> 🛠️ **Auto Formatter:** Code is automatically formatted by **Biome** (or Prettier as a fallback) every time you save a file (`Ctrl + s`).

---

## ⚡ 4. Autocomplete (blink.cmp)
*Active while in Insert Mode:*

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`Ctrl` + `Space`** | Open Suggestions / View Docs | Show the completion menu or toggle the detailed documentation view. |
| **`Ctrl` + `e`** | Hide Suggestions | Close the currently visible completion menu. |
| **`Enter` (`<CR>`)** | Confirm Selection | Insert the currently selected suggestion into the code (Accept suggestion). |
| **`Tab`** | Select Next / Snippet | Jump to the next snippet placeholder, or move down to the next suggestion. |
| **`Shift` + `Tab`** | Select Previous / Snippet | Jump to the previous snippet placeholder, or move up to the previous suggestion. |
| **`Ctrl` + `j`** | Move Down | Move the selection cursor down to the suggestion below. |
| **`Ctrl` + `k`** | Move Up | Move the selection cursor up to the suggestion above. |
| **`Ctrl` + `f`** | Scroll Docs Down | Scroll the documentation panel downward. |
| **`Ctrl` + `b`** | Scroll Docs Up | Scroll the documentation panel upward. |

---

## ⚙️ 5. Editing Operations & Advanced Clipboard

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`Ctrl` + `s`** | Quick Save | Works in all modes (Insert, Normal, Visual). |
| **`Ctrl` + `q`** | Quit Neovim | Close the current editor window. |
| **`Space` + `a`** | Select All | Select the entire file content (`ggVG`). |
| **`>` (Visual mode)** | Indent Right | Indent the selected code block and keep the selection active. |
| **`<` (Visual mode)** | Indent Left | Unindent the selected code block and keep the selection active. |
| **`H`** | Go to Line Start | Quickly move the cursor to the first character of the line. |
| **`L`** | Go to Line End | Quickly move the cursor to the last character of the line. |
| **`J`** | Join Line Below | Join the line below onto the current line while keeping the cursor position. |
| **`Ctrl` + `d`** | Scroll Down | Scroll half a page down and automatically center the cursor on screen. |
| **`Ctrl` + `u`** | Scroll Up | Scroll half a page up and automatically center the cursor on screen. |
| **`n` / `N`** | Navigate Search Results | Jump to the next / previous search result and center it on screen. |
| **`Space` + `nh`** | Clear Highlights | Remove the highlight color from search results after searching. |
| **`Space` + `o`** | Add Line Below | Add one blank line below without entering Insert mode. |
| **`Space` + `O`** | Add Line Above | Add one blank line above without entering Insert mode. |
| **`Space` + `p` (Visual)** | Paste Over (Keep Clipboard) | Paste over the selected code without overwriting the clipboard with the replaced content. |
| **`Space` + `dl`** | Delete Line | Quickly delete the current line. |
| **`Space` + `D`** | Delete to Black Hole | Delete content into the black hole register (does not overwrite the clipboard). |
| **`Ctrl` + `c` (Insert)** | Exit Insert Mode | Return to Normal mode safely, similar to pressing `Esc`. |
| **`Alt` + `j` / `k`** | Move Line | Move the current line (or selected block) down / up. |
| **`Alt` + `Shift` + `j` / `k`** | Duplicate Line | Quickly copy and paste the current line downward / upward. |
| **`Space` + `s` + `s`** | Quick Replace | Find and replace the word under the cursor throughout the current file. |
| **`Space` + `u`** | Open UndoTree | Open the undo history tree to navigate back through editing history. |
| **`Space` + `m` + `x`** | Run chmod +x | Grant executable permissions to the current script file. |
| **`Space` + `q` + `q`** | Format Brackets | Automatically reformat and align elements inside parentheses, brackets, or braces across multiple lines. |
| **`Space` + `c` + `c`** | PHP Format | Automatically reformat PHP code using php-cs-fixer. |

---

## 🌳 6. Smart Selection (Treesitter Text Objects)
*Use these in Visual Mode (to select) or Operator-Pending Mode (after an operator like `d` to delete, `y` to copy):*

| Keymap | Selection Scope | Description |
| :--- | :--- | :--- |
| **`a` + `f`** | Entire function | Select the entire structure of a function/method (Outer function). |
| **`i` + `f`** | Function body | Select only the code inside the function body (Inner function body). |
| **`a` + `c`** | Entire class | Select the entire class structure (Outer class). |
| **`i` + `c`** | Class body | Select only the code inside the class definition (Inner class body). |

+---

## 🌳 7. Code Folding (nvim-ufo)

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`z` + `R`** | Open all folds | Expand all folded code blocks in the current file (Expand All). |
| **`z` + `M`** | Close all folds | Collapse all code blocks in the current file (Collapse All). |
| **`z` + `r`** | Open fold levels | Gradually open fold levels, excluding certain structure types. |
| **`z` + `m`** | Close fold levels | Gradually collapse code folds by level. |
| **`z` + `a`** | Toggle fold under cursor | Toggle open/close the single code block under the cursor (like clicking the gutter arrow). |
| **`z` + `c`** | Close current fold | Close only the code block under the cursor. |
| **`z` + `o`** | Open current fold | Open only the code block under the cursor. |

---

## ⚡ 8. Terminal & Window Management (Windows / Panes)

### **Integrated Terminal (ToggleTerm)**
*   **`Ctrl` + `\`** : Toggle the integrated terminal at the bottom of the screen.
*   **`Esc` + `Esc`** : Exit Terminal Mode and return to Normal Mode (while inside the terminal), allowing you to copy text or scroll through logs.

### **Pane Navigation & Resizing**
*Works in both Normal and Terminal Mode:*
*   **`Ctrl` + `h`** $\rightarrow$ Move to the window on the left.
*   **`Ctrl` + `l`** $\rightarrow$ Move to the window on the right.
*   **`Ctrl` + `j`** $\rightarrow$ Move to the window below.
*   **`Ctrl` + `k`** $\rightarrow$ Move to the window above.
*   **`Tab`** $\rightarrow$ Cycle focus through all open split windows.
*   **`Ctrl` + `Up` / `Down`** $\rightarrow$ Increase / Decrease the height of the current split window.
*   **`Ctrl` + `Left` / `Right`** $\rightarrow$ Increase / Decrease the width of the current split window.

---

## 🌳 9. Git Integration (Neogit & Diffview)

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`Space` + `gn`** | Git Panel (Neogit) | Open the highly visual Git management panel. Press `s` to stage, `c` to commit, `p` to push. |
| **`Space` + `gc`** | Git Commit | Quickly open the commit message editor via Neogit. |
| **`Space` + `gd`** | Diffview Open | Open a side-by-side diff view showing all file changes. |
| **`Space` + `gD`** | Diffview Close | Close the Diffview interface. |
| **`Space` + `g` + `a`** | Git Stage Current File | Add (stage) the currently active file to the Git index using Gitsigns. |
| **`Space` + `g` + `e`** | Git Status Float | Open a floating window showing the current repository status via Neo-tree. |

---

## 📝 10. Diagnostics & Miscellaneous Utilities

| Keymap | Feature | Description |
| :--- | :--- | :--- |
| **`Space` + `xx`** | Project-wide Diagnostics | Open a list of all errors and warnings (LSP Diagnostics) across the entire project via Trouble. |
| **`Space` + `xX`** | Current File Diagnostics | View the error list for only the currently open file (Buffer Diagnostics). |
| **`Space` + `cs`** | Symbols List | Open a list of all symbols (variables, functions, etc.) in the current file via Trouble. |
| **`Space` + `cl`** | LSP List | View LSP definitions and references via Trouble. |
| **`Space` + `co`** | Open Quickfix List | Open the Quickfix list window for reviewing errors and changes. |
| **`Space` + `c` + `l`** | Close Quickfix List | Close the Quickfix list window. |
| **`Space` + `cn`** | Next Quickfix Item | Jump to the next item in the Quickfix list. |
| **`Space` + `cp`** | Previous Quickfix Item | Jump to the previous item in the Quickfix list. |
| **`Space` + `k`** | Next Location Item | Jump to the next item in the Location list. |
| **`Space` + `j`** | Previous Location Item | Jump to the previous item in the Location list. |
| **`Space` + `xL`** | Location List | Toggle the Location list window. |
| **`Space` + `xQ`** | Quickfix List | Toggle the Quickfix list window. |
| **`Space` + `z`** | Zen Mode | Toggle Zen Mode (hides all status bars for distraction-free coding). |
| **`Space` + `S` + `s`** | Save Session | Save the current working session (open files, tabs, splits) to disk. |
| **`Space` + `S` + `r`** | Restore Session | Restore a previously saved working session. |
| **`Space` + `mp`** | Markdown Preview | Open a live browser preview of the current Markdown file in real time. |
| **`Space` + `mS`** | Stop MD Preview | Stop the Markdown Preview server. |
| **`Space` + `b` + `p`** | Pin Current Tab | Manually pin the current tab (prevents it from being auto-closed when opening new files). |
| **`Double-click Left Mouse`** | Pin Preview Tab | Double-click a Preview tab to permanently pin it as a regular tab. |
| **`Alt` + `h` / `l`** | Buffer Tabs | Quickly navigate to the previous / next file tab at the top of the screen (Alt+h/l). |