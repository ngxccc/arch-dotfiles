return {
	"lewis6991/gitsigns.nvim",
	-- Lazy load: Only activate the plugin when opening a file with existing content or creating a new file
	event = { "BufReadPre", "BufNewFile" },
	opts = function()
		return {
			-- Standard Nerd Font icon set, clean and refined
			signs = {
				add = { text = "▎" }, -- Thick vertical bar (Added lines)
				change = { text = "▎" }, -- Thick vertical bar (Modified lines)
				delete = { text = "" }, -- Right-pointing triangle arrow (Deleted lines)
				topdelete = { text = "" }, -- Triangle arrow (Deletion at the top of the file)
				changedelete = { text = "▍" }, -- Slightly indented vertical bar (Modified and deleted)
				untracked = { text = "┆" }, -- Dashed bar (New file not yet git added)
			},

			-- Enable the sign column to display icons
			signcolumn = true,

			-- [Practical]: Automatically highlight the background of line numbers
			-- Allows instant visual identification of changed code regions without looking to the left
			numhl = false,

			watch_gitdir = {
				follow_files = true,
			},
			attach_to_untracked = true,

			-- [Pro Tip]: Enable inline Git Blame for the current line.
			-- Extremely useful when debugging to identify who committed a line and when.
			current_line_blame = true,
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- Display virtual ghost text at the End Of Line
				delay = 500, -- Wait 0.5s after the cursor stops before rendering the text (prevents lag)
			},
		}
	end,
}