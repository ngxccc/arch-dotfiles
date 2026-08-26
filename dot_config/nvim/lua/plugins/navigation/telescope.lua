return {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Fuzzy Find Files" },
    {
      "<leader>fa",
      function()
        require("telescope.builtin").find_files({ hidden = true })
      end,
      desc = "Find All Files (including hidden)",
    },
    { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find Recent Files (Oldfiles)" },
    { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Find Quickfix List" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Telescope help tags" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope buffers" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Search Keymaps (Telescope)" },
    {
      "<leader>fg",
      function()
        require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") })
      end,
      desc = "Search string in workspace (Grep)",
    },
    {
      "<leader>fc",
      function()
        local filename_without_extension = vim.fn.expand("%:t:r")
        require("telescope.builtin").grep_string({ search = filename_without_extension })
      end,
      desc = "Find current file occurrences",
    },
    {
      "<leader>fs",
      function()
        require("telescope.builtin").grep_string({})
      end,
      desc = "Find word under cursor",
    },
    {
      "<leader>fi",
      function()
        require("telescope.builtin").find_files({ cwd = "~/.config/nvim/" })
      end,
      desc = "Find files in Neovim config",
    },
    { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Find Word in Workspace (Live Grep)" },
  },
  config = function()
    local actions = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })
  end,
}
