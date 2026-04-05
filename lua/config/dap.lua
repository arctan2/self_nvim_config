local dap = require("dap")
local dapui = require("dapui")

local js_debug_path = vim.fn.expand("$HOME/daps/vscode-js-debug/dist/src/dapDebugServer.js")

dap.adapters["pwa-node"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { js_debug_path, "${port}" },
	},
}

dap.adapters["pwa-chrome"] = {
	type = "server",
	host = "localhost",
	port = "${port}",
	executable = {
		command = "node",
		args = { os.getenv("HOME") .. "/daps/vscode-js-debug/dist/src/dapDebugServer.js", "${port}" },
	},
}

dap.adapters["node"] = function(cb, config)
	config.type = "pwa-node"
	local a = dap.adapters["pwa-node"]
	if type(a) == "function" then a(cb, config) else cb(a) end
end

local node_config = {
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch project",
		runtimeExecutable = "npx",
		runtimeArgs = { "ts-node" },
		program = "${workspaceFolder}/src/index.ts",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		outFiles = { "${workspaceFolder}/dist/**/*.js" },
		resolveSourceMapLocations = {
			"${workspaceFolder}/**",
			"!**/node_modules/**",
		},
		console = "integratedTerminal",
		skipFiles = { "<node_internals>/**" },
	},
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch current file (ts-node)",
		runtimeExecutable = "npx",
		runtimeArgs = { "ts-node", "--esm" },
		program = "${file}",
		cwd = "${workspaceFolder}",
		sourceMaps = true,
		console = "integratedTerminal",
		skipFiles = { "<node_internals>/**" },
	},
	{
		type = "pwa-node",
		request = "launch",
		name = "Launch current file (node, compiled JS)",
		program = "${file}",
		cwd = "${workspaceFolder}",
		console = "integratedTerminal",
		skipFiles = { "<node_internals>/**" },
	},
}

for _, ft in ipairs({ "typescript", "javascript" }) do
	dap.configurations[ft] = node_config
end

local function get_url()
	return coroutine.wrap(function()
		local co = coroutine.running()
		vim.ui.input({ prompt = "URL: ", default = "http://localhost:3000" }, function(url)
			coroutine.resume(co, url)
		end)
	end)()
end

local web_config = {
	{
		type = "pwa-chrome",
		request = "launch",
		name = "Astro: Launch Brave",
		url = get_url,
		runtimeExecutable = "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser",
		webRoot = "${workspaceFolder}",
		sourceMaps = true,
		sourceMapPathOverrides = {
			["astro:///*"] = "${workspaceFolder}/*",
		},
		userDataDir = false,
	},
	{
		type = "pwa-chrome",
		request = "attach",
		name = "Astro: Attach Brave",
		port = 9222,
		urlFilter = "http://localhost:4321/*",
		webRoot = "${workspaceFolder}",
		sourceMaps = true,
		sourceMapPathOverrides = {
			["astro:///*"] = "${workspaceFolder}/*",
		},
	},
}

require('dap-go').setup({
	dap_configurations = {
		{
			type = "go",
			name = "Debug App (./cmd/app/app.go)",
			request = "launch",
			program = "${workspaceFolder}/cmd/app",
			cwd = "${workspaceFolder}",
			envFile = "${workspaceFolder}/.env",
			outputMode = "remote"
		},
	},
})

dap.configurations.javascriptreact = web_config
dap.configurations.typescriptreact = web_config
dap.configurations.vue = web_config
dap.configurations.astro = node_config

dapui.setup()
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
-- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
-- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end


vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_over)
vim.keymap.set("n", "<F3>", dap.step_into)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dc", dapui.close)
