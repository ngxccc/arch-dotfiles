return {
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.icons",
      "refractalize/oil-git-status.nvim",
    },
    cmd = { "Oil" },
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open Parent Directory (Oil)" },
      { "<leader>e", "<cmd>Oil --float<cr>", desc = "File Explorer Float (Oil)" },
      { "<leader>E", "<cmd>Oil<cr>", desc = "File Explorer Fullscreen (Oil)" },
      { "<leader>cd", "<cmd>Oil<cr>", desc = "Open Oil File Manager" },
    },
    opts = function()
      local detail = false
      return {
        default_file_explorer = true,
        delete_to_trash = true,
        columns = {
          "icon",
        },
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
          autosave_changes = true,
        },
        git = {
          add = function(path) return true end,
          mv = function(src_path, dest_path) return true end,
          rm = function(path) return true end,
        },
        win_options = {
          signcolumn = "yes:2",
          winbar = "%!v:lua.get_oil_winbar()",
        },
        view_options = {
          show_hidden = true,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = "rounded",
          win_options = {
            winblend = 0,
          },
        },
        keymaps = {
          ["g?"] = "actions.show_help",
          ["<CR>"] = "actions.select",
          ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
          ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
          ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open in new tab" },
          ["<C-p>"] = "actions.preview",
          ["q"] = "actions.close",
          ["<Esc>"] = "actions.close",
          ["<C-c>"] = "actions.close",
          ["<C-l>"] = "actions.refresh",
          ["-"] = "actions.parent",
          ["_"] = "actions.open_cwd",
          ["`"] = "actions.cd",
          ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to current directory" },
          ["gs"] = "actions.change_sort",
          ["gx"] = "actions.open_external",
          ["g."] = "actions.toggle_hidden",
          ["g\\"] = "actions.toggle_trash",
          ["gd"] = {
            desc = "Toggle file detail view",
            callback = function()
              detail = not detail
              if detail then
                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
              else
                require("oil").set_columns({ "icon" })
              end
            end,
          },
        },
      }
    end,
    config = function(_, opts)
      require("oil").setup(opts)
      local ok, git_status = pcall(require, "oil-git-status")
      if ok then
        git_status.setup({
          show_ignored = false,
        })
      end
    end,
    init = function()
      function _G.get_oil_winbar()
        local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
        local dir = require("oil").get_current_dir(bufnr)
        if dir then
          return "   " .. vim.fn.fnamemodify(dir, ":~")
        end
        return ""
      end
    end,
  },
}