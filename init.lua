vim.pack.add({
	{ src = "https://github.com/jesseleite/nvim-noirbuddy" },
	{ src = "https://github.com/tjdevries/colorbuddy.nvim" },
	{ src = "https://github.com/brenoprata10/nvim-highlight-colors" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", version = 'main' },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/echasnovski/mini.completion" },

	{ src = "https://github.com/arctan2/scratch.nvim" },
	{ src = "https://github.com/arctan2/curl.nvim" },

	{ src = "https://github.com/mfussenegger/nvim-dap" },
	{ src = "https://github.com/rcarriga/nvim-dap-ui" },
	{ src = "https://github.com/nvim-neotest/nvim-nio" },
	{ src = "https://github.com/leoluz/nvim-dap-go" },

	{ src = "https://github.com/nvim-lua/plenary.nvim" },

	-- git
	{ src = "https://github.com/nvim-mini/mini.diff" },
})

require("config")
pcall(require, "local_config")

