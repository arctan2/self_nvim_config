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
			outputMode = "remote",
		},
	},
})

dap.configurations.javascriptreact = web_config
dap.configurations.typescriptreact = web_config
dap.configurations.vue = web_config
dap.configurations.astro = node_config

dapui.setup({
	layouts = {
		{
			elements = {
				{ id = "breakpoints", size = 0.25 },
				{ id = "scopes", size = 0.75 },
			},
			size = 40,
			position = "left",
		},
		{
			elements = {
				{ id = "repl", size = 1 },
			},
			size = 10,
			position = "bottom",
		},
	},
})
dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
-- dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
-- dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end


vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_over)
vim.keymap.set("n", "<F3>", dap.step_into)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dc", dapui.close)
vim.keymap.set("n", "<leader>dt", dap.terminate, { desc = "DAP: terminate session" })
vim.keymap.set("n", "<leader>dr", function()
	if dap.session() then
		dap.terminate({}, {}, function()
			dap.run_last()
		end)
	else
		dap.run_last()
	end
end, { desc = "DAP: restart (terminate + relaunch last)" })

-- Interactive variable tree, similar to dapui's scopes window but in a
-- floating scratch buffer so it behaves like a normal buffer (search, yank,
-- navigate with regular motions).
local VarTree = {}
VarTree.__index = VarTree

function VarTree.new(session, expr)
	local self = setmetatable({}, VarTree)
	self.session = session
	self.expr = expr
	self.buf = vim.api.nvim_create_buf(false, true)
	self.nodes = {} -- line number (1-indexed) -> node
	self.root = { name = expr, evaluateName = expr, depth = 0, expanded = true, children = nil }
	vim.bo[self.buf].filetype = "go"
	vim.bo[self.buf].buftype = "nofile"
	vim.bo[self.buf].bufhidden = "wipe"
	vim.bo[self.buf].modifiable = false
	return self
end

function VarTree:fetch_children(node, cb)
	if node.children ~= nil then
		cb()
		return
	end
	if not node.variablesReference or node.variablesReference == 0 then
		node.children = {}
		cb()
		return
	end
	self.session:request("variables", { variablesReference = node.variablesReference }, function(err, res)
		vim.schedule(function()
			node.children = {}
			if not err and res and res.variables then
				for _, v in ipairs(res.variables) do
					local eval_name = v.evaluateName
					if not eval_name or eval_name == "" then
						if node.evaluateName and node.evaluateName ~= "" then
							eval_name = node.evaluateName .. "." .. v.name
						else
							eval_name = v.name
						end
					end
					table.insert(node.children, {
						name = v.name,
						value = v.value,
						variablesReference = v.variablesReference,
						evaluateName = eval_name,
						depth = node.depth + 1,
						expanded = false,
						children = nil,
					})
				end
			end
			cb()
		end)
	end)
end

function VarTree:render()
	local lines = {}
	self.nodes = {}

	local function add_line(node, text)
		table.insert(lines, text)
		self.nodes[#lines] = node
	end

	local function walk(node)
		for _, child in ipairs(node.children or {}) do
			local has_children = child.variablesReference and child.variablesReference > 0
			local indent = string.rep("  ", child.depth)
			local marker = has_children and (child.expanded and "v " or "> ") or "  "
			local text
			if child.value and child.value ~= "" then
				text = string.format("%s%s%s: %s", indent, marker, child.name, child.value)
			else
				text = string.format("%s%s%s", indent, marker, child.name)
			end
			add_line(child, text)
			if has_children and child.expanded then
				walk(child)
			end
		end
	end

	add_line(self.root, self.expr .. " =")
	walk(self.root)

	vim.bo[self.buf].modifiable = true
	vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
	vim.bo[self.buf].modifiable = false
end

function VarTree:toggle_at_cursor(win)
	local lnum = vim.api.nvim_win_get_cursor(win)[1]
	local node = self.nodes[lnum]
	if not node then return end
	if not node.variablesReference or node.variablesReference == 0 then return end

	if node.expanded then
		node.expanded = false
		self:render()
		vim.api.nvim_win_set_cursor(win, { lnum, 0 })
	else
		self:fetch_children(node, function()
			node.expanded = true
			self:render()
			vim.api.nvim_win_set_cursor(win, { lnum, 0 })
		end)
	end
end

function VarTree:open()
	local width = math.floor(vim.o.columns * 0.90)
	local height = math.floor(vim.o.lines * 0.90)
	local win = vim.api.nvim_open_win(self.buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = "minimal",
		border = "rounded",
		title = " " .. self.expr .. " ",
		title_pos = "center",
	})

	local opts = { buffer = self.buf, silent = true }
	vim.keymap.set("n", "q", "<cmd>close<cr>", opts)
	vim.keymap.set("n", "<esc>", "<cmd>close<cr>", opts)
	vim.keymap.set("n", "<cr>", function() self:toggle_at_cursor(win) end, opts)
	vim.keymap.set("n", "o", function() self:toggle_at_cursor(win) end, opts)

	self:fetch_children(self.root, function()
		self.root.expanded = true
		self:render()
	end)
end

local function open_variable_buffer()
	local session = dap.session()
	if not session then
		vim.notify("No active debug session", vim.log.levels.WARN)
		return
	end

	-- Get the expression under cursor, falling back to visual selection
	local expr
	local mode = vim.fn.mode()
	if mode == "v" or mode == "V" then
		vim.cmd('noau normal! "vy"')
		expr = vim.fn.getreg("v")
	else
		expr = vim.fn.expand("<cexpr>")
	end

	if not expr or expr == "" then
		vim.notify("No expression under cursor", vim.log.levels.WARN)
		return
	end

	session:evaluate(expr, function(err, response)
		if err then
			vim.schedule(function()
				vim.notify("Eval failed: " .. tostring(err.message or err), vim.log.levels.ERROR)
			end)
			return
		end

		vim.schedule(function()
			local tree = VarTree.new(session, expr)
			tree.root.variablesReference = response.variablesReference or 0
			tree.root.value = response.result
			tree:open()
		end)
	end)
end

vim.keymap.set({ "n", "v" }, "<leader>dv", open_variable_buffer, { desc = "DAP: open variable in buffer" })
