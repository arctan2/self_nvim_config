local utils = require("config.utils")

-- removing these things
vim.keymap.set("v", "K", function() end)
vim.keymap.set("n", "<PageDown>", function() end)
vim.keymap.set("n", "<PageUp>", function() end)
vim.keymap.set("i", "<PageDown>", function() end)
vim.keymap.set("i", "<PageUp>", function() end)

-- completions
vim.keymap.set("i", "<C-f>", "<C-x><C-f>", { noremap = true })
vim.keymap.set("i", "<C-o>", "<C-x><C-o>", { noremap = true })

-- cycle windows
vim.keymap.set("n", "<C-L>", "<C-w>w")
vim.keymap.set("n", "<C-H>", "<C-w>W")

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

