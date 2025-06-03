return {
	"cvigilv/esqueleto.nvim",
	lazy = false,
	config = function()
		require("esqueleto").setup({
			patterns = { "cs" },
			directories = { vim.fn.stdpath("config") .. "/lua/skeletons/" },
			autouse = true,
			wildcards = {
				expand = true,
				lookup = {
					["namespace"] = function()
						local cwd = vim.fn.getcwd()
						return vim.fn.fnamemodify(cwd, ":t")
					end,
					["project"] = function()
						local cwd = vim.fn.getcwd()
						return vim.fn.fnamemodify(cwd, ":t")
					end,
				},
			},
		})
	end,
}
