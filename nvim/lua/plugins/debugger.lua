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

		dapui.setup()
		dap.adapters.coreclr = {
			type = "executable",
			command = "/usr/bin/netcoredbg",
			args = { "--interpreter=vscode" },
		}

		local env = {
			ASPNETCORE_ENVIRONMENT = "Development",
		}

		dap.configurations.cs = {
			{
				name = "Run .NET Core",
				type = "coreclr",
				request = "launch",
				cwd = vim.fn.getcwd(),
				environment = env,
				program = function()
					local dlls = vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/net*/**/*.dll", false, true)
					if #dlls == 0 then
						vim.notify("❌ No DLL found. Did you forget to build?", vim.log.levels.ERROR)
						return vim.fn.input("Path to DLL: ", vim.fn.getcwd() .. "/bin/Debug/net8.0/", "file")
					end
					return dlls[1] -- Pick the first one
				end,
				before = function(config)
					print("Building...")

					local result = vim.fn.system("dotnet build")
					if vim.v.shell_error ~= 0 then
						vim.notify("Build failed:\n" .. result, vim.log.levels.ERROR)
						print("Build failed")
						return false
					end

					print("Build succeeded")
					return true
				end,
			},
		}

		vim.keymap.set("n", "<F5>", function()
			dap.continue()
		end, { desc = "Start Debugging" })
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
