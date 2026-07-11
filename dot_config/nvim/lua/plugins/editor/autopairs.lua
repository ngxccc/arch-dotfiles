return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",

  opts = {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" }, -- ignore pairs inside both string and raw source nodes in Lua
      javascript = { "template_string" },
      java = false, -- TS check on Java can be sluggish; disable to avoid edge-case lag
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" }, -- prevent autopairs from interfering in search prompts
    fast_wrap = {
      map = "<M-e>", -- press Alt + E to instantly wrap with brackets (FastWrap mechanism)
      chars = { "{", "[", "(", "\"", "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- cursor offset after wrapping
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
  },

}