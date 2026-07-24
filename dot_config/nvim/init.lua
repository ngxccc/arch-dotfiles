vim.loader.enable()

-- Silence deprecation warnings for get_active_clients
if vim.lsp.get_clients then
  vim.lsp.get_active_clients = vim.lsp.get_clients
end

require("config.options")
require("config.keybinds")
require("config.lazy")
require("config.preview").setup()
