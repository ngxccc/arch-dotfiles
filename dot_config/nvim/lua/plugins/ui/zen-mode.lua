return {
	"folke/zen-mode.nvim",
	cmd = "ZenMode",
	keys = {
		-- Press Space + z to Toggle Zen Mode
		{ "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
	},
	opts = {
		window = {
			backdrop = 0.95, -- Dim surrounding UI elements (95%)
			width = 100, -- Constrain code width to a readable centered column
			options = {
				signcolumn = "no", -- Hide the sign column
				number = false, -- Hide line numbers
				relativenumber = false,
				cursorline = false,
			},
		},
		plugins = {
			-- Integration: Notify WezTerm when Zen Mode is active so it can dim its borders automatically
			wezterm = { enabled = true, font = "+4" }, -- Automatically increase font size by 4px for better readability
		},
	},
}