return {
	tailwindcss = {
		cmd = { "tailwindcss-language-server", "--stdio" },
		filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact" },
		settings = {
			tailwindCSS = {
				experimental = { classRegex = {} },
				includeLanguages = {
					javascript = "javascript",
					typescript = "typescript",
					javascriptreact = "html",
					typescriptreact = "html",
				},
			},
		},
	},
}
