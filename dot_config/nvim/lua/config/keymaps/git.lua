-- 🌿 GIT SHORTCUTS (<leader>g group)

vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<cr>", { desc = "Git Status (Changed Files Popup)" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Git Branches Popup" })
vim.keymap.set("n", "<leader>gl", "<cmd>Telescope git_commits<cr>", { desc = "Git Commit Log Popup" })
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit Panel" })
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "Git Diffview Open" })
vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewClose<cr>", { desc = "Git Diffview Close" })
local function with_gitsigns(fn)
  return function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then
      vim.notify("Gitsigns not loaded", vim.log.levels.ERROR)
      return
    end
    fn(gitsigns)
  end
end

local function nav_hunk(direction, diff_motion)
  return function()
    if vim.wo.diff then
      vim.cmd.normal({ diff_motion, bang = true })
      return
    end
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then
      vim.notify("Gitsigns not loaded", vim.log.levels.ERROR)
      return
    end
    gitsigns.nav_hunk(direction)
  end
end

vim.keymap.set("n", "<leader>ga", with_gitsigns(function(gs)
  gs.stage_buffer()
  vim.notify("Staged current buffer successfully", vim.log.levels.INFO)
end), { desc = "Git Add (Stage) Current File" })

-- 🔍 GITSIGNS HUNK NAVIGATION & ACTIONS
vim.keymap.set("n", "]h", nav_hunk("next", "]c"), { desc = "Next Git Hunk" })
vim.keymap.set("n", "[h", nav_hunk("prev", "[c"), { desc = "Previous Git Hunk" })

vim.keymap.set("n", "<leader>gp", with_gitsigns(function(gs)
  gs.preview_hunk()
end), { desc = "Git Preview Hunk (Float)" })

vim.keymap.set("n", "<leader>gi", with_gitsigns(function(gs)
  gs.preview_hunk_inline()
end), { desc = "Git Preview Hunk (Inline)" })

vim.keymap.set("n", "<leader>gh", with_gitsigns(function(gs)
  gs.stage_hunk()
end), { desc = "Git Stage / Unstage Hunk" })

vim.keymap.set("x", "<leader>gh", with_gitsigns(function(gs)
  gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end), { desc = "Git Stage / Unstage Selected Hunk" })

vim.keymap.set("n", "<leader>gr", with_gitsigns(function(gs)
  gs.reset_hunk()
end), { desc = "Git Reset Hunk" })

vim.keymap.set("x", "<leader>gr", with_gitsigns(function(gs)
  gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
end), { desc = "Git Reset Selected Hunk" })

vim.keymap.set("n", "<leader>gR", with_gitsigns(function(gs)
  gs.reset_buffer()
end), { desc = "Git Reset Current Buffer" })

vim.keymap.set("n", "<leader>gf", with_gitsigns(function(gs)
  gs.diffthis()
end), { desc = "Git Diff Current File (Split)" })

vim.keymap.set("n", "<leader>gB", with_gitsigns(function(gs)
  gs.blame_line({ full = true })
end), { desc = "Git Blame Line (Full)" })

vim.keymap.set({ "o", "x" }, "ih", with_gitsigns(function(gs)
  gs.select_hunk()
end), { desc = "Select Git Hunk" })
