return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		local profiles = require("config.profiles")
		local lua_formatters = require("config.profiles.formatters.lua")
		local python_formatters = require("config.profiles.formatters.python")
		local web_formatters = require("config.profiles.formatters.web")
		local shell_formatters = require("config.profiles.formatters.shell")

		local formatters = profiles.merge_maps(lua_formatters, python_formatters, web_formatters, shell_formatters)

		require("conform").setup({
			formatters_by_ft = formatters,
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
		})
	end,
}
