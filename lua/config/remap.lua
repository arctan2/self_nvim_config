local utils = require("config.utils")

-- removing these things
vim.keymap.set("v", "K", function() end)
vim.keymap.set("n", "<PageDown>", function() end)
vim.keymap.set("n", "<PageUp>", function() end)
vim.keymap.set("i", "<PageDown>", function() end)
vim.keymap.set("i", "<PageUp>", function() end)

-- cycle windows
vim.keymap.set("n", "<C-l>", "<C-w>w")
vim.keymap.set("n", "<C-h>", "<C-w>W")

-- focus out of terminal window to adjacent split
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- moving the visual-line blocks up and down
vim.keymap.set("v", "<c-k>", function ()
	local to = vim.fn.getcurpos()[2]
	local from = vim.fn.getpos("v")[2]
	local cmd = math.min(from, to)..","..math.max(from, to).."m"..(math.min(from, to) - 2)..";"..tostring(to)

	vim.cmd(cmd)

	utils.visual_select(from - 1, to - 1)
end)

vim.keymap.set("v", "<c-y>", "\"+y")

vim.keymap.set("v", "<c-j>", function ()
	local from = vim.fn.getpos("v")[2]
	local to = vim.fn.getcurpos()[2]

	local cmd = math.min(from, to)..","..math.max(from, to).."m"..(math.max(from, to) + 1)..";"..tostring(to)

	vim.cmd(cmd)

	utils.visual_select(from + 1, to + 1)
end)

vim.keymap.set("v", "<leader>r", function()
	local text = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
	local escaped = vim.fn.escape(table.concat(text, "\n"), "/\\")
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("<Esc>:%s/" .. escaped .. "/", true, false, true),
		"n", false
	)
end)

