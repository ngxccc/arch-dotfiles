return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "│", right = "│" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        -- Left side
        lualine_a = { "mode" },
        lualine_b = { "diagnostics" },
        lualine_c = {
          {
            "filename",
            path = 1, -- 🚀 1: Relative Path (ví dụ: src/database/database.module.ts)
            fmt = function(name)
              if name:match("^oil://") then
                local dir = name:gsub("^oil://", "")
                return vim.fn.fnamemodify(dir, ":~")
              end
              return name
            end,
          },
          -- 🛠️ Custom component to indicate when a macro is being recorded
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end
              return "⏺ Recording @" .. reg
            end,
            cond = function()
              return vim.fn.reg_recording() ~= ""
            end,
            color = { fg = "#ff9e64", gui = "bold" },
          },
        },

        -- Right side
        lualine_x = {
          -- 🛠️ Custom component to show active LSP clients (đã loại bỏ utf-8, fileformat, filetype rác)
          {
            function()
              local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
              if next(buf_clients) == nil then
                return ""
              end
              local buf_client_names = {}
              for _, client in ipairs(buf_clients) do
                table.insert(buf_client_names, client.name)
              end
              return "LSP: " .. table.concat(buf_client_names, ", ")
            end,
            icon = " ",
            color = { fg = "#cba6f7", gui = "bold" },
            -- 🚀 Ẩn bớt text LSP khi màn hình quá hẹp (< 80 cột) để ưu tiên số 1 cho File Path
            cond = function()
              return vim.o.columns > 80
            end,
          },
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
