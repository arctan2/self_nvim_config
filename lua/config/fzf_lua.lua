local fzf = require("fzf-lua")

fzf.setup {
	keymap = {
		fzf = {
			["ctrl-q"] = "select-all+accept",
		},
	},
	winopts = {
		preview = {
			vertical     = "down:45%",
			horizontal   = "right:40%",
		},
	}
}

vim.keymap.set('n', '<leader>pf', fzf.files, {})
vim.keymap.set('n', '<C-p>', fzf.git_files, {})
vim.keymap.set('n', '<leader>fb', fzf.buffers, {})
vim.keymap.set('n', '<leader>ot', fzf.tabs, {})

vim.keymap.set('n', '<leader>nc', function()
	fzf.files {
		cwd = vim.fn.stdpath("config")
	}
end)

vim.keymap.set('n', '<leader>qfe', function()
	vim.diagnostic.setqflist({
		open = false,
		title = "Errors",
		severity = vim.diagnostic.severity.ERROR
	})

	fzf.quickfix()
end)

vim.keymap.set('n', '<leader>qfw', function()
	vim.diagnostic.setqflist({
		open = false,
		title = "Warnings",
		severity = vim.diagnostic.severity.WARN
	})

	fzf.quickfix()
end)

vim.keymap.set('n', '<leader>qfa', function()
	vim.diagnostic.setqflist({
		open = false,
		title = "All",
	})

	fzf.quickfix()
end)

vim.keymap.set('n', '<leader>pg', fzf.live_grep, {})
