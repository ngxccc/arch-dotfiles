return {
	lua_ls = {
		cmd = { "lua-language-server" },
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				format = { enable = true },
				telemetry = { enable = false },
				workspace = { checkThirdParty = false },
				completion = { callSnippet = "Replace" },
				formatting = { defaultConfig = { indent_style = "space", indent_size = 2 } },
			},
		},
	},
}
