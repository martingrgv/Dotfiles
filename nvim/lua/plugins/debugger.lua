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

		dap.configurations.cs = {
			{
				name = "Run .NET Core",
				type = "coreclr",
				request = "launch",
				cwd = vim.fn.getcwd(),
				env = {
					ASPNETCORE_ENVIRONMENT = "Development",
				},
				program = function()
					vim.notify("Started debugging...", vim.log.levels.DEBUG)

					local cwd = vim.fn.getcwd()
					local projectName = vim.fn.fnamemodify(cwd, ":t")
					local dllPattern = cwd .. "/bin/Debug/net*/" .. projectName .. ".dll"
					local projectDlls = vim.fn.glob(dllPattern, false, true)

					vim.notify("cwd: " .. cwd, vim.log.levels.DEBUG)
					vim.notify("project name: " .. projectName, vim.log.levels.DEBUG)

					if #projectDlls == 0 then
						vim.notify("❌ Project DLL not found! Did you forget to build?", vim.log.levels.ERROR)
						return vim.fn.input("Path to DLL: ", cwd .. "/", "file")
					end

					local dllPath = projectDlls[1]
					vim.notify("dll path: " .. dllPath, vim.log.levels.DEBUG)

					if vim.fn.filereadable(dllPath) == 1 then
						return dllPath
					end

					vim.notify("❌ DLL not readable!", vim.log.levels.ERROR)
					return vim.fn.input("Path to DLL: ", cwd .. "/", "file")
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
		vim.keymap.set("n", "<F6>", function()
			dap.terminate()
		end, { desc = "Stop Debugging" })
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
		vim.keymap.set("n", "<Leader>dj", function()
			dap.goto_(vim.fn.getcurpos()[2])
		end, { desc = "Debugger - Set next statement" })

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
