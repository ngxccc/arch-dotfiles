return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")


		lint.linters_by_ft = {
			lua = { "luacheck" },
			python = { "mypy" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			markdown = { "markdownlint" },
			php = { "phpstan" },
		}

		-- Configure luacheck to recognize Neovim's vim global and suppress false warnings
		lint.linters.luacheck.args = {
			"--globals",
			"vim",
			"--ignore",
			"631",
			"--formatter",
			"plain",
			"--codes",
			"-",
		}

		-- Configure markdownlint arguments to use the global config file ~/.markdownlint.jsonc
		lint.linters.markdownlint.args = {
			"--stdin",
			"--config",
			vim.fn.expand("~/.markdownlint.jsonc"),
		}
		-- Automatically run the linter on file save or when leaving insert mode (InsertLeave)
		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("UserLinting", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}