return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",

  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" }, -- bỏ qua pair trong cả string và source code thô của Lua
      javascript = { "template_string" },
      java = false, -- Đôi khi TS check trên Java khá lag, có thể tắt đi (Edge case)
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" }, -- Tránh autopair làm phiền ở thanh tìm kiếm
    fast_wrap = {
      map = "<M-e>", -- Bấm Alt + E để bọc ngoặc siêu tốc (FastWrap mechanism)
      chars = { "{", "[", "(", "\"", "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Dịch chuyển con trỏ sau khi wrap
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  },

}
