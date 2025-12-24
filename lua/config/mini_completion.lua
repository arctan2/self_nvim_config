local utils = require("config.utils")

require("mini.completion").setup {
	delay = { completion = 100, info = 100, signature = 50 },
	lsp_completion = {
		source_func = 'completefunc',
		auto_setup = true,
		-- process_items = function(items, base)
		-- 	local seen = {}
		-- 	local result = {}

		-- 	for _, item in ipairs(items) do
		-- 		local label = item.label or item.word or item.insertText or item
		-- 		if not seen[label] then
		-- 			seen[label] = true
		-- 			table.insert(result, item)
		-- 		end
		-- 	end

		-- 	return result
		-- end,
	},
}

