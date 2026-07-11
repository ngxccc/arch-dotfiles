return {
  {
    "echasnovski/mini.icons",
    lazy = false,
    priority = 1001, -- Load early to mock nvim-web-devicons before other plugins
    opts = {},
    config = function(_, opts)
      local icons = require("mini.icons")
      icons.setup(opts)
      icons.mock_nvim_web_devicons()
    end,
  },
}