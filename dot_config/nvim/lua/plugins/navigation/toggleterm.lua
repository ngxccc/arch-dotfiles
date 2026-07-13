return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<C-t>]], -- Use Ctrl + t to quickly toggle the terminal
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal", -- Terminal opens at the bottom in a horizontal split
      close_on_exit = true,
    })

    -- Configure keymaps for Terminal mode to make window navigation easier
    function _G.set_terminal_keymaps()
      -- Press Esc twice to switch from Terminal mode to Normal mode (avoids conflicts with lazygit/fzf)
      vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { buffer = 0, desc = "Escape Terminal Mode" })
      -- Navigate between windows from the terminal
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = 0, desc = "Go to Left Window" })
      -- Use Ctrl j/k/l to move to another window
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = 0, desc = "Go to Lower Window" })
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = 0, desc = "Go to Upper Window" })
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = 0, desc = "Go to Right Window" })
      -- Resize windows from the terminal
      vim.keymap.set("t", "<C-Up>", [[<Cmd>resize +2<CR>]], { buffer = 0, desc = "Resize Terminal Height +" })
      vim.keymap.set("t", "<C-Down>", [[<Cmd>resize -2<CR>]], { buffer = 0, desc = "Resize Terminal Height -" })
      vim.keymap.set("t", "<C-Left>", [[<Cmd>vertical resize -2<CR>]], { buffer = 0, desc = "Resize Terminal Width -" })
      vim.keymap.set("t", "<C-Right>", [[<Cmd>vertical resize +2<CR>]], { buffer = 0, desc = "Resize Terminal Width +" })
    end

    -- Automatically activate these keymaps when a terminal is opened
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}