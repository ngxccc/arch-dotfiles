return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = "VeryLazy",
  keys = {
    { "zR", function() require("ufo").openAllFolds() end, desc = "Open All Folds (UFO)" },
    { "zM", function() require("ufo").closeAllFolds() end, desc = "Close All Folds (UFO)" },
    { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open Folds Except Kinds (UFO)" },
    { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close Folds With (UFO)" },
  },
  init = function()
    -- Configure visual code fold display
    vim.o.foldcolumn = "1"     -- Display fold indicator column on the left side of lines (similar to VS Code)
    vim.o.foldlevel = 99       -- High default value to prevent auto-closing folds when opening a new file
    vim.o.foldlevelstart = 99  -- Start new files with all folds open
    vim.o.foldenable = true    -- Enable code folding by default
  end,
  config = function()
    -- Handler function to render decorative virtual text next to folded lines (e.g., " 󰁂 15 lines ")
    local handler = function(virtText, lnum, endLnum, width, truncate)
      local newVirtText = {}
      local suffix = (" 󰁂 %d lines "):format(endLnum - lnum)
      local sufWidth = vim.fn.strdisplaywidth(suffix)
      local targetWidth = width - sufWidth
      local curWidth = 0
      for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
          table.insert(newVirtText, chunk)
        else
          chunkText = truncate(chunkText, targetWidth - curWidth)
          local hlGroup = chunk[2]
          table.insert(newVirtText, { chunkText, hlGroup })
          chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if curWidth + chunkWidth < targetWidth then
            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
          end
          break
        end
        curWidth = curWidth + chunkWidth
      end
      table.insert(newVirtText, { suffix, "MoreMsg" })
      return newVirtText
    end

    require("ufo").setup({
      provider_selector = function(bufnr, filetype, buftype)
        -- Prefer Treesitter (fast and accurate), with automatic fallback to Indent
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = handler,
    })
  end,
}