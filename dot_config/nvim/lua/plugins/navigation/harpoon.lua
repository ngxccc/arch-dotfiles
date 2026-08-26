local function toggle_telescope(harpoon_files)
  local conf = require("telescope.config").values
  local themes = require("telescope.themes")

  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  local opts = themes.get_ivy({
    prompt_title = " 󰛔 Harpoon Working List ",
  })

  require("telescope.pickers")
    .new(opts, {
      prompt_title = opts.prompt_title,
      finder = require("telescope.finders").new_table({
        results = file_paths,
      }),
      previewer = conf.file_previewer(opts),
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "<leader>ha",
      function()
        require("harpoon"):list():add()
        vim.notify("󰛔 Added to Harpoon: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
      end,
      desc = "Harpoon: Add File",
    },
    {
      "<C-e>",
      function()
        local h = require("harpoon")
        h.ui:toggle_quick_menu(h:list())
      end,
      desc = "Harpoon: Quick Menu",
    },
    {
      "<leader>fl",
      function()
        toggle_telescope(require("harpoon"):list())
      end,
      desc = "Harpoon: Telescope Picker",
    },
    {
      "<C-p>",
      function()
        require("harpoon"):list():prev()
      end,
      desc = "Harpoon: Previous File",
    },
    {
      "<C-n>",
      function()
        require("harpoon"):list():next()
      end,
      desc = "Harpoon: Next File",
    },
    -- Direct 1-4 index jumps (Instant 0ms file switching)
    { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: File 1" },
    { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: File 2" },
    { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: File 3" },
    { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: File 4" },
    { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "Harpoon: File 1" },
    { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "Harpoon: File 2" },
    { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "Harpoon: File 3" },
    { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "Harpoon: File 4" },
  },
  config = function()
    require("harpoon"):setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    })
  end,
}