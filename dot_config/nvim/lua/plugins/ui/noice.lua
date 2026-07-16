return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lsp = {
      -- override markdown rendering so that cmp/blink and other plugins use Treesitter
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      signature = {
        enabled = false,
      },
    },
    -- enable presets for floating command palette and search
    presets = {
      bottom_search = true, -- use a classic bottom search bar for search
      command_palette = true, -- position the cmdline and popupmenu together in the center
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    views = {
      mini = {
        timeout = 5000, -- Show mini/popup notifications for 5 seconds (5000ms)
      },
    },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
  }
}
