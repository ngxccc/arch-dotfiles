return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local profiles = require("config.profiles")
		local python_linters = require("config.profiles.linters.python")
		local web_linters = require("config.profiles.linters.web")
		local shell_linters = require("config.profiles.linters.shell")

		local lint = require("lint")

		lint.linters_by_ft = profiles.merge_maps(python_linters, web_linters, shell_linters)

		-- Tự động chạy linter mỗi khi lưu file hoặc rảnh tay (InsertLeave)
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("UserLinting", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
