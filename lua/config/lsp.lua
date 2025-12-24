require('lspconfig.ui.windows').default_options.border = 'rounded'
vim.o.winborder = 'rounded'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" }
			}
		}
	}
})

vim.lsp.config('html', {
	capabilities = capabilities,
	filetypes = { "html", "templ" }
})

vim.lsp.config('cssls', {
	capabilities = capabilities,
	filetypes = { "css", "scss", "less" }
})

local vue_language_server_path = '/usr/lib/node_modules/@vue/language-server'
local typescript_lib_path = '/usr/lib/node_modules/typescript/lib'

vim.lsp.config('vtsls', {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
	},
	settings = {
		typescript = {
			tsdk = typescript_lib_path,
		},
		vtsls = {
			tsserver = {
				globalPlugins = {
					{
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
						languages = { "vue" },
						location = vue_language_server_path,
						name = "@vue/typescript-plugin",
					},
				},
			},
		},
	}
})

vim.lsp.config("vue_ls", { capabilities = capabilities, filetypes = { "vue" } })

vim.lsp.config("angularls", {
	root_markers = { "angular.json" }
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

local _border = "rounded"

vim.diagnostic.config {
	float = { border = _border },
	virtual_text = true
}

vim.opt.updatetime = 100

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
	vim.lsp.handlers.hover, {
		border = _border
	}
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = _border })

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		local opts = { buffer = ev.buf }
		-- local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- if client:supports_method("textDocument/completion") then
		-- 	vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		-- end

		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<leader>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>fo', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

vim.lsp.enable({
	"vtsls",
	"lua_ls",
	"rust_analyzer",
	"gopls",
	"html",
	"cssls",
	"pyright",
	"zls",
	"clangd",
	"angularls",
	"jdtls",
})
