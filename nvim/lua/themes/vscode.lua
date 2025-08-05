return {
	"Mofiqul/vscode.nvim",
	--name = "vscode",
	lazy = false,
	priority = 1001,
	config = function()
		vim.o.background = "dark"
		require("vscode").setup({
			transparent = true,
			terminal_colors = true,
			italic_comments = true,
		})

		vim.cmd.colorscheme("vscode")
	end,
}
