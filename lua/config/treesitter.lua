local config = require("nvim-treesitter.config")

local parser_dir = vim.fn.stdpath("data") .. "/parsers"
vim.fn.mkdir(parser_dir, "p")

vim.opt.runtimepath:prepend(parser_dir)

local ensure_installed = {
    "c", "rust", "go", "javascript", "typescript",
    "lua", "vim", "vimdoc", "python", "css",
    "html", "tsx", "query", "vue",
}

config.setup {
    parser_install_dir = parser_dir,
    ensure_installed = ensure_installed,
    highlight = { enable = true },
}

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local filetype = args.match
		local lang = vim.treesitter.language.get_lang(filetype)
		if vim.treesitter.language.add(lang) then
			vim.treesitter.start()
		end
	end
})
