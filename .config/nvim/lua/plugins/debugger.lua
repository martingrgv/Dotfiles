return { -- C# Debugger
	"mfussenegger/nvim-dap",
	lazy = false,
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dapwidgets = require("dap.ui.widgets")

		require("easy-dotnet.netcoredbg").register_dap_variables_viewer()
		dapui.setup()

		dap.adapters.coreclr = {
			type = "executable",
			command = "/usr/local/netcoredbg",
			args = { "--interpreter=vscode" },
		}

		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "launch - netcoredbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
				stopOnEntry = false,
				env = "Development",
			},
		}

		dap.listeners.before["launch"].build_project = function()
			print("Building...")

			local sln = vim.fn.glob("**/*.sln")
			vim.notify("Building project solution: " .. sln)

			local result = vim.fn.system("dotnet build " .. sln)

			if vim.v.shell_error ~= 0 then
				vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
			end

			vim.notify("Build success:\n" .. result, vim.log.levels.INFO)
		end

		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end, { desc = "Start Debugging" })
		vim.keymap.set("n", "<F6>", function()
			dap.terminate()
		end, { desc = "Stop Debugging" })
		vim.keymap.set("n", "<F7>", function()
			dap.restart()
		end, { desc = "Restart Session" })
		vim.keymap.set("n", "<F10>", function()
			dap.step_over()
		end, { desc = "Step Over" })
		vim.keymap.set("n", "<F11>", function()
			dap.step_into()
		end, { desc = "Step Into" })
		vim.keymap.set("n", "<F12>", function()
			dap.step_out()
		end, { desc = "Step Out" })
		vim.keymap.set("n", "<Leader>b", function()
			dap.toggle_breakpoint()
		end, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<Leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Conditional Breakpoint" })
		vim.keymap.set("n", "<Leader>du", function()
			dapui.toggle()
		end, { desc = "Toggle DAP UI" })
		vim.keymap.set("n", "<Leader>wh", function()
			dapwidgets.hover()
		end, { desc = "Hover widgets" })
		vim.keymap.set("n", "<Leader>vp", function()
			dapwidgets.preview()
		end, { desc = "Preview widgets" })
		vim.keymap.set("n", "<Leader>wt", function()
			dapwidgets.centered_float(dapwidgets.frames)
		end, { desc = "Stack Trace" })
		vim.keymap.set("n", "<Leader>wr", function()
			dapwidgets.centered_float(dapwidgets.scopes)
		end, { desc = "Scopes" })
		vim.keymap.set("n", "<Leader>dj", function()
			dap.focus_frame()
		end, { desc = "Focus current frame" })
		vim.keymap.set("n", "<Leader>dc", function()
			dap.goto_()
		end, { desc = "Jump to cursor" })
		vim.keymap.set("n", "<Leader>dr", function()
			dap.run_to_cursor()
		end, { desc = "Run to cursor" })

		-- Auto open/close dap-ui when debugging starts/stops
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
}
