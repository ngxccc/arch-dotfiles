return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        -- 🚀 "auto" automatically extracts colors from the current theme (Tokyonight, VSCode, etc.)
        theme = "auto",
        -- 🚀 Modern standard: Use a single status bar for the entire Neovim instance
        globalstatus = true,

        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        -- Left side
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = {
          "filename",

          -- 🛠️ Custom component to indicate when a macro is being recorded
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end -- Hidden when not recording
              return "⏺ Recording @" .. reg
            end,
            -- The `cond` flag tells Lualine when to render this component
            cond = function()
              return vim.fn.reg_recording() ~= ""
            end,
            color = { fg = "#ff9e64", gui = "bold" }, -- Orange alert color
          },
        },

        -- Right side
        lualine_x = {
          -- 🛠️ Custom component to show active LSP clients in the current buffer
          {
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if next(buf_clients) == nil then
                return "No LSP"
              end
              local buf_client_names = {}
              for _, client in ipairs(buf_clients) do
                table.insert(buf_client_names, client.name)
              end
              return "LSP: " .. table.concat(buf_client_names, ", ")
            end,
            icon = " ",
            color = { fg = "#cba6f7", gui = "bold" }, -- Mauve highlight color matching Catppuccin
          },
          "encoding",
          "fileformat",
          "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
