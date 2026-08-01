vim.keymap.set("v", "<leader>r", function()
	local text = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
	local escaped = vim.fn.escape(table.concat(text, "\n"), "/\\")
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes("<Esc>:%s/" .. escaped .. "/", true, false, true),
		"n", false
	)
end)

vim.keymap.set("v", "<leader>sg", function()
	local text = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
	local query = table.concat(text, "\n")
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
	vim.schedule(function()
		require("fzf-lua").live_grep({ query = query })
	end)
end)


