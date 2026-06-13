require("claudecode").setup({
	port_range = { min = 10000, max = 65535 },
	auto_start = true,
	log_level = "info",
	terminal_cmd = nil,

	focus_after_send = false,

	track_selection = true,
	visual_demotion_delay_ms = 50,

	terminal = {
		split_side = "right",
		split_width_percentage = 0.30,
		provider = "auto",
		auto_close = true,
		snacks_win_opts = {},
		provider_opts = {
			external_terminal_cmd = nil,
		},
	},

	diff_opts = {
		layout = "vertical",
		open_in_new_tab = false,
		keep_terminal_focus = false,
		hide_terminal_in_new_tab = false,
	},
})

local map = vim.keymap.set
map("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
map("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
map("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
map("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
map("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
map("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
map("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
map("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
map("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
	callback = function(ev)
		vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>",
			{ desc = "Add file", buffer = ev.buf })
	end,
})
