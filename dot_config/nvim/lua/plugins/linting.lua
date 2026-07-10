return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")


		lint.linters_by_ft = {
			python = { "mypy" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			markdown = { "markdownlint" },
		}

		-- Cấu hình tham số cho markdownlint sử dụng file config toàn cục ~/.markdownlint.jsonc
		lint.linters.markdownlint.args = {
			"--stdin",
			"--config",
			vim.fn.expand("~/.markdownlint.jsonc"),
		}
		-- Tự động chạy linter mỗi khi lưu file hoặc rảnh tay (InsertLeave)
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("UserLinting", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
