return {
  -- 1. vim-fugitive: The go-to Git CLI command interface
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
  },

  -- 2. Diffview: VS Code-style diff viewer and conflict resolver
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
    opts = function()
      local actions = require("diffview.actions")
      return {
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = "diff2_horizontal",
          },
        },
        keymaps = {
          view = {
            { "n", "<leader>e", actions.focus_files, { desc = "Bring focus to the file panel" } },
          },
          file_panel = {
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel" } },
            { "n", "<cr>", actions.focus_entry, { desc = "Open the diff and focus it" } },
          },
          file_history_panel = {
            { "n", "<leader>e", actions.toggle_files, { desc = "Toggle the file panel" } },
            { "n", "<cr>", actions.focus_entry, { desc = "Open the diff and focus it" } },
          },
        },
        hooks = {
          diff_buf_read = function(bufnr)
            for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
              vim.lsp.buf_detach_client(bufnr, client.id)
            end
          end,
        },
      }
    end,
  },

  -- 3. Neogit: Native Source Control Panel interface and Git Graph
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "Neogit" },
    opts = {
      disable_commit_confirmation = true,
      graph_style = "unicode",
      integrations = {
        diffview = true,
        telescope = true,
      },
    },
  },
}
