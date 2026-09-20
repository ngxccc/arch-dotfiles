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
    },
    opts = function()
      local detail = false

      local function parse_output(proc)
        local result = proc:wait()
        local ret = {}
        if result.code == 0 then
          for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
            line = line:gsub("/$", "")
            ret[line] = true
          end
        end
        return ret
      end

      local function new_git_status()
        return setmetatable({}, {
          __index = function(self, key)
            local ignore_proc = vim.system(
              { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
              { cwd = key, text = true }
            )
            local ret = {
              ignored = parse_output(ignore_proc),
              is_git = ignore_proc:wait().code == 0,
            }
            rawset(self, key, ret)
            return ret
          end,
        })
      end
      local git_status = new_git_status()

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
          signcolumn = "auto:2",
          winbar = "%!v:lua.get_oil_winbar()",
        },
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, bufnr)
            if name == ".." or name == ".git" then
              return true
            end
            local dir = require("oil").get_current_dir(bufnr)
            if not dir then
              return vim.startswith(name, ".")
            end
            local st = git_status[dir]
            if not st.is_git then
              return vim.startswith(name, ".")
            end
            -- Dim ONLY files and directories that are truly matched by .gitignore
            return st.ignored[name] == true
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 30,
          border = "rounded",
          win_options = {
            winblend = 0,
            signcolumn = "auto:2",
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
          ["<C-l>"] = {
            desc = "Refresh directory and Git status cache",
            callback = function()
              git_status = new_git_status()
              require("oil.actions").refresh.callback()
            end,
          },
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
          ["yp"] = {
            desc = "Copy relative path to clipboard",
            callback = function()
              local entry = require("oil").get_cursor_entry()
              local dir = require("oil").get_current_dir()
              if entry and dir then
                local full_path = dir .. entry.name
                local rel_path = vim.fn.fnamemodify(full_path, ":.")
                vim.fn.setreg("+", rel_path)
                vim.fn.setreg('"', rel_path)
                vim.notify("Copied relative path: " .. rel_path, vim.log.levels.INFO)
              end
            end,
          },
          ["ya"] = {
            desc = "Copy absolute path to clipboard",
            callback = function()
              local entry = require("oil").get_cursor_entry()
              local dir = require("oil").get_current_dir()
              if entry and dir then
                local full_path = vim.fn.fnamemodify(dir .. entry.name, ":p")
                vim.fn.setreg("+", full_path)
                vim.fn.setreg('"', full_path)
                vim.notify("Copied absolute path: " .. full_path, vim.log.levels.INFO)
              end
            end,
          },
          ["yn"] = {
            desc = "Copy filename to clipboard",
            callback = function()
              local entry = require("oil").get_cursor_entry()
              if entry then
                vim.fn.setreg("+", entry.name)
                vim.fn.setreg('"', entry.name)
                vim.notify("Copied filename: " .. entry.name, vim.log.levels.INFO)
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