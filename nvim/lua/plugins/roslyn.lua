return {
	"seblyng/roslyn.nvim",
	ft = { "cs", "razor" },
	dependencies = {
		{
			"tris203/rzls.nvim",
			config = true,
		},
	},
	config = function()
		local mason_registry = require("mason-registry")

		local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
		local cmd = {
			"roslyn",
			"--stdio",
			"--logLevel=Information",
			"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
			"--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
			"--razorDesignTimePath="
				.. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
			"--extension",
			vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
		}

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		vim.lsp.config("roslyn", {
			cmd = cmd,
			handlers = require("rzls.roslyn_handlers"),
			settings = {
				["csharp|inlay_hints"] = {
					csharp_enable_inlay_hints_for_implicit_object_creation = true,
					csharp_enable_inlay_hints_for_implicit_variable_types = true,
				},
				["csharp|code_lens"] = {
					dotnet_enable_references_code_lens = true,
				},
			},
		})

		vim.lsp.enable("roslyn")
	end,
	init = function()
		vim.filetype.add({
			extension = {
				razor = "razor",
				cshtml = "razor",
			},
		})
	end,
}

-- return {
-- 	"seblyng/roslyn.nvim",
-- 	ft = "cs",
-- 	config = function()
-- 		local capabilities = vim.lsp.protocol.make_client_capabilities()
-- 		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
--
-- 		require("roslyn").setup({
-- 			dotnet_cmd = "dotnet",
-- 			roslyn_version = "4.8.0-3.23475.7",
-- 		})
-- 	end,
-- }
