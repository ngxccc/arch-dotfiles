local M = {}

-- Track the current preview buffer
vim.g.preview_buf = nil

-- Check if a buffer is a real file candidate for previewing
local function is_preview_candidate(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  local buftype = vim.bo[bufnr].buftype
  local buflisted = vim.bo[bufnr].buflisted
  local filetype = vim.bo[bufnr].filetype
  local name = vim.api.nvim_buf_get_name(bufnr)

  return buftype == "" and buflisted and filetype ~= "" and name ~= ""
end

-- Check if a buffer is visible in any window
local function is_buf_visible(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end
  return #vim.fn.win_findbuf(bufnr) > 0
end

-- Pin the current buffer (remove preview state)
function M.pin_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if vim.b[bufnr].is_preview then
    vim.b[bufnr].is_preview = false
    if vim.g.preview_buf == bufnr then
      vim.g.preview_buf = nil
    end
    vim.cmd("redrawtabline")
    vim.notify("📌 File pinned successfully!", vim.log.levels.INFO)
  end
end

-- Setup preview buffer autocommands
function M.setup()
  -- Mark all currently loaded buffers as pinned (not preview)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.b[bufnr].is_preview = false
    end
  end

  local group = vim.api.nvim_create_augroup("PreviewBuffers", { clear = true })

  -- When entering a buffer, manage preview lifecycle
  vim.api.nvim_create_autocmd({ "BufEnter" }, {
    group = group,
    callback = function(ev)
      local bufnr = ev.buf

      if not is_preview_candidate(bufnr) then
        return
      end

      -- If this buffer is already pinned/edited, don't make it preview again
      if vim.b[bufnr].is_preview == false then
        return
      end

      -- If we are entering a new preview candidate
      if vim.g.preview_buf and vim.g.preview_buf ~= bufnr then
        local prev = vim.g.preview_buf
        -- Delete the old preview buffer if it is valid, still a preview, and not visible
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(prev) and vim.b[prev].is_preview == true then
            if not vim.bo[prev].modified and not is_buf_visible(prev) then
              pcall(vim.api.nvim_buf_delete, prev, { force = true })
            end
          end
        end)
      end

      -- Set current buffer as the active preview buffer if it's a new preview buffer
      if vim.b[bufnr].is_preview == nil then
        vim.b[bufnr].is_preview = true
      end
      
      -- Only track it as the active preview if it is indeed in preview state
      if vim.b[bufnr].is_preview == true then
        vim.g.preview_buf = bufnr
      end
      vim.cmd("redrawtabline")
    end,
  })

  -- Pin buffer on modification
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = group,
    callback = function(ev)
      local bufnr = ev.buf
      if vim.b[bufnr].is_preview then
        vim.b[bufnr].is_preview = false
        if vim.g.preview_buf == bufnr then
          vim.g.preview_buf = nil
        end
        vim.cmd("redrawtabline")
      end
    end,
  })

  -- Pin buffer on double-click
  vim.keymap.set("n", "<2-LeftMouse>", function()
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.b[bufnr].is_preview then
      M.pin_buffer(bufnr)
    end
    return "<2-LeftMouse>"
  end, { expr = true, silent = true })

  -- Manual pin mapping
  vim.keymap.set("n", "<leader>bp", function()
    M.pin_buffer()
  end, { desc = "Pin current buffer" })
end

return M