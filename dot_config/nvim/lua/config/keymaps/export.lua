-- 📤 AUTOMATIC KEYMAP EXPORT COMMAND

vim.api.nvim_create_user_command("ExportKeymaps", function()
  -- Load lazy plugins so all keymaps are available in RAM
  local ok_lazy, lazy = pcall(require, "lazy")
  if ok_lazy then
    pcall(lazy.load, {
      plugins = {
        "nvim-treesitter",
        "harpoon",
        "telescope.nvim",
        "oil.nvim",
        "gitsigns.nvim",
        "diffview.nvim",
        "neogit",
      },
    })
  end

  local modes = {
    { mode = "n", label = "Normal" },
    { mode = "x", label = "Visual" },
    { mode = "o", label = "Operator" },
    { mode = "i", label = "Insert" },
    { mode = "t", label = "Terminal" },
  }

  local mode_labels = {
    n = "Normal",
    x = "Visual",
    v = "Visual",
    o = "Operator",
    i = "Insert",
    t = "Terminal",
  }

  local lines = {
    "# 🚀 Automatically Generated Neovim Keymaps",
    "",
    "Generated on: " .. os.date("%Y-%m-%d %H:%M:%S"),
    "",
    "| Keymap | Mode | Action / Description |",
    "| :--- | :--- | :--- |",
  }

  local desc_overrides = {
    ["vim.lsp.buf.code_action()"] = "LSP Code Action",
    ["vim.lsp.buf.implementation()"] = "LSP Go to Implementation",
    ["vim.lsp.buf.rename()"] = "LSP Rename Symbol",
    ["vim.lsp.buf.references()"] = "LSP Show References",
    ["vim.lsp.buf.type_definition()"] = "LSP Go to Type Definition",
    ["vim.lsp.buf.document_symbol()"] = "LSP Document Symbols",
    ["vim.lsp.codelens.run()"] = "LSP Run CodeLens",
  }

  local sorted_maps = {}
  local seen = {}

  for _, m in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(m.mode)
    for _, map in ipairs(keymaps) do
      local desc = map.desc
      if desc and (desc:sub(1, 6) == ":help " or desc:sub(1, 1) == ":") then
        desc = nil
      end

      if desc and desc ~= "" then
        desc = desc_overrides[desc] or desc
        local lhs = map.lhs:gsub(" ", "<leader>")
        local key_id = m.mode .. ":" .. lhs
        if not seen[key_id] then
          seen[key_id] = true
          table.insert(sorted_maps, { lhs = lhs, mode = m.label, desc = desc })
        end
      end
    end
  end

  -- Buffer-local LSP keymaps are not returned by nvim_get_keymap(), so pull
  -- them from the same SSOT used by LspAttach.
  local ok_lsp, lsp_keymaps = pcall(require, "config.lsp_keymaps")
  if ok_lsp then
    for _, map in ipairs(lsp_keymaps) do
      local mode_list = type(map[1]) == "table" and map[1] or { map[1] }
      for _, m in ipairs(mode_list) do
        local key_id = m .. ":" .. map[2]
        if not seen[key_id] then
          seen[key_id] = true
          table.insert(sorted_maps, {
            lhs = map[2],
            mode = mode_labels[m] or m,
            desc = map[4],
          })
        end
      end
    end
  end

  table.sort(sorted_maps, function(a, b)
    if a.lhs == b.lhs then
      return a.mode < b.mode
    end
    return a.lhs < b.lhs
  end)

  for _, map in ipairs(sorted_maps) do
    table.insert(lines, string.format("| **`%s`** | %s | %s |", map.lhs, map.mode, map.desc))
  end

  table.insert(lines, "")
  table.insert(
    lines,
    "> Blink.cmp insert-mode keys (`<Tab>`, `<S-Tab>`, `<C-j>`, `<C-k>`, `<C-Space>`, `<C-e>`, `<CR>`, `<C-f>`, `<C-b>`, `<C-x>`) are internal to blink.cmp and do not appear in `nvim_get_keymap()`."
  )

  local file_path = vim.fn.stdpath("config") .. "/KEYMAPS_AUTOGEN.md"
  local f = io.open(file_path, "w")
  if f then
    f:write(table.concat(lines, "\n") .. "\n")
    f:close()
    vim.notify("Successfully exported clean keymaps to " .. file_path, vim.log.levels.INFO)
  else
    vim.notify("Failed to write keymaps file", vim.log.levels.ERROR)
  end
end, { desc = "Export all active keymaps to Markdown" })
