return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	config = function()
		local neotree = require("neo-tree")
		neotree.setup({
			close_if_last_window = true,
			filesystem = {
				follow_current_file = true,
			},
		})

		vim.api.nvim_set_keymap("n", "<leader><CR>", ":Neotree toggle<CR>", { noremap = true, silent = true })
	end,
}
