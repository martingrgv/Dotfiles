return {
	"seblyng/roslyn.nvim",
	ft = "cs",
	config = function()
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		require("roslyn").setup({
			dotnet_cmd = "dotnet",
			roslyn_version = "4.8.0-3.23475.7",
		})
	end,
}
