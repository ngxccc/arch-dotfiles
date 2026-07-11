return {
	{
		"kkoomen/vim-doge",
		build = ":call doge#install()",
		cmd = { "DogeGenerate" }, -- Only load plugin when the doc generation command is invoked
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Toggle UndoTree" },
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = "BufReadPre", -- Startup optimization: Only load after a file has been read
		config = function()
			require("nvim-highlight-colors").setup({
				render = "background", -- Render colors as background highlights for clear visibility
				enable_tailwind = true, -- Useful option if you are using TailwindCSS
			})
		end,
	},
}