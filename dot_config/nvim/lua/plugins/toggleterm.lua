return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]], -- Sử dụng Ctrl + \ để bật/tắt terminal nhanh
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "horizontal", -- Terminal sẽ mở ở phía dưới dạng hàng ngang
      close_on_exit = true,
    })

    -- Cấu hình phím tắt cho Terminal mode để dễ dàng thao tác di chuyển cửa sổ
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      -- Bấm Esc 2 lần để chuyển từ Terminal mode về Normal mode (không xung đột với lazygit/fzf)
      vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
      -- Di chuyển giữa các cửa sổ từ Terminal
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      -- Dùng Cmd j/k/l để di chuyển sang cửa sổ khác
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      -- Resize cửa sổ từ Terminal
      vim.keymap.set("t", "<C-Up>", [[<Cmd>resize +2<CR>]], opts)
      vim.keymap.set("t", "<C-Down>", [[<Cmd>resize -2<CR>]], opts)
      vim.keymap.set("t", "<C-Left>", [[<Cmd>vertical resize -2<CR>]], opts)
      vim.keymap.set("t", "<C-Right>", [[<Cmd>vertical resize +2<CR>]], opts)
    end

    -- Tự động kích hoạt các phím tắt này khi mở terminal
    vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
  end,
}
