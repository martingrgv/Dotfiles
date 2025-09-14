return {
	"tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
	lazy = false,
	event = "VimEnter",
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
}
