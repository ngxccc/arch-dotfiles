return {
  {
    "echasnovski/mini.icons",
    lazy = false,
    priority = 1001, -- Tải sớm để giả lập nvim-web-devicons trước các plugin khác
    opts = {},
    config = function(_, opts)
      local icons = require("mini.icons")
      icons.setup(opts)
      icons.mock_nvim_web_devicons()
    end,
  },
}
