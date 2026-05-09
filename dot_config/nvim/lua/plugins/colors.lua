return {
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false, -- Đảm bảo theme load ngay từ đầu
	-- 	priority = 1000,
	-- 	opts = {
	-- 		transparent = true, -- 🚀 Tokyonight tự động lo vụ trong suốt từ A-Z!
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
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
