return { -- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	event = "VimEnter",
	lazy = false,
	build = ":TSUpdate",
	main = "nvim-treesitter.configs",

	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"markdown_inline",
			"query",
			"vim",
			"vimdoc",
			"c_sharp",
		},
		auto_install = true,
		highlight = {
			enable = true,
		},
		indent = { enable = true },
	},
}
