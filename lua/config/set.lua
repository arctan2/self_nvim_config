vim.opt.guicursor = "n-v-c-sm-i-ci-ve:block,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

vim.api.nvim_create_autocmd({ "VimLeave" }, {
	pattern = "*",
	callback = function ()
	vim.opt.guicursor = "a:block-blinkon0"
	end
})

-- vim.opt.clipboard = "unnamedplus"

vim.opt.shell = "zsh"

-- vim.opt.list = true
-- vim.opt.listchars = "tab:  ┊"

vim.opt.list = true
vim.opt.listchars = "tab:  ·"

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorlineopt = "number"
vim.opt.cursorline = true

vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.incsearch = true
vim.opt.hlsearch = false

vim.opt.termguicolors = true

vim.opt.signcolumn = "yes"

vim.opt.scrolloff = 8

vim.g.netrw_keepdir = true

vim.g.netrw_winsize = 30

-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.g.mapleader = " "

vim.g.zig_fmt_autosave = false

vim.opt.foldopen = vim.opt.foldopen - "block"

vim.opt.completeopt = "menu,menuone,noselect"

vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = "*",
	callback = function ()
		vim.opt.formatoptions:remove("r")
		vim.opt.formatoptions:remove("o")
	end
})
