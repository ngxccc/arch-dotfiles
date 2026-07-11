return {
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false, -- Ensure the theme loads immediately at startup
	-- 	priority = 1000,
	-- 	opts = {
	-- 		transparent = true, -- 🚀 Tokyonight automatically handles transparency from A to Z!
	-- 		styles = {
	-- 			sidebars = "transparent",
	-- 			floats = "transparent",
	-- 		},
	-- 	},
	-- 	config = function(_, opts)
	-- 		require("tokyonight").setup(opts)
	-- 		vim.cmd.colorscheme("tokyonight")
	-- 	end,
	-- },
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1001,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				integrations = {
					treesitter = true,
					native_lsp = {
						enabled = true,
					},
				},
				custom_highlights = function(colors)
					return {
						NormalFloat = { bg = colors.mantle },
						FloatBorder = { fg = colors.blue, bg = colors.mantle },
					}
				end,
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}