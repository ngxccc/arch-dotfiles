return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
          },
        },
      },
    })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy Find Files" })
    vim.keymap.set("n", "<leader>fa", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find All Files (including hidden)" })
    vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Find Recent Files (Oldfiles)" })
    vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Find Quickfix List" })
    vim.keymap.set(
      "n",
      "<leader>fh",
      builtin.help_tags,
      { desc = "Telescope help tags" }
    )
    vim.keymap.set(
      "n",
      "<leader>fb",
      builtin.buffers,
      { desc = "Telescope buffers" }
    )
    vim.keymap.set(
      "n",
      "<leader>fk",
      builtin.keymaps,
      { desc = "Search Keymaps (Telescope)" }
    )

    -- Rip grep + Fzf
    vim.keymap.set("n", "<leader>fg", function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Search string in workspace (Grep)" })

    -- Find instance instance of current view being included
    vim.keymap.set("n", "<leader>fc", function()
      local filename_without_extension = vim.fn.expand("%:t:r")
      builtin.grep_string({ search = filename_without_extension })
    end, { desc = "Find current file occurrences" })

    vim.keymap.set("n", "<leader>fs", function()
      builtin.grep_string({})
    end, { desc = "Find word under cursor" })

    vim.keymap.set("n", "<leader>fi", function()
      builtin.find_files({ cwd = "~/.config/nvim/" })
    end, { desc = "Find files in Neovim config" })
    vim.keymap.set(
      "n",
      "<leader>fw",
      builtin.live_grep,
      { desc = "Find Word in Workspace (Live Grep)" }
    )
  end,
}
