local nts = require("nvim-treesitter")

local ensure_installed = {
	"c",
	"rust",
	"go",
	"javascript",
	"typescript",
	"lua",
	"vim",
	"vimdoc",
	"python",
	"css",
	"html",
	"tsx",
	"query",
	"vue",
	"c_sharp"
}

local alreadyInstalled = require("nvim-treesitter.config").get_installed()

local parsersToInstall = vim.iter(ensure_installed)
	:filter(function(parser) return not vim.tbl_contains(alreadyInstalled, parser) end)
	:totable()

nts.install(parsersToInstall)

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.treesitter.language.add(lang) then
			vim.treesitter.start()
		end
	end
})
