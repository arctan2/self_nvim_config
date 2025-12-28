local colorbuddy = require('colorbuddy')
local Color = colorbuddy.Color
local colors = colorbuddy.colors
local Group = colorbuddy.Group

require("noirbuddy").setup({
	colors = {
		background = "#131313",
		primary = "#19D420",
		secondary = "#FFFFFF",
		noir_2 = "#FFFFFF",
		noir_3 = "#FFFFFF",
		noir_4 = "#FFFFFF",
		noir_5 = "#FFFFFF",
		noir_6 = "#FFFFFF",
		noir_7 = "#AAAAAA",
	}
})

local primary = "#ffff00"
local secondary = "#0080ff"
local folder_color = primary

local custom_colors = {
	OilDir = { fg = folder_color },
	LineNr = { fg = "#505050" },
	CursorLine = { bg = "#404040", fg = "#FFFFFF" },
	CursorLineNr = { fg = "#DDDDDD" },
	MatchParen = { bg = "#505050", fg = primary },
	PmenuSel = { bg = "#505050", fg = "#FFFFFF" },
	Pmenu = { bg = "#303030", fg = "#888888" },
	StatusLine = { bg = "#FFFFFF", fg = "#000000" },
	StatusLineNC = { bg = "#606060", fg = "#000000" },
	ErrorMsg = { fg = "#ff3b3b", bg = "#131313" },
	MoreMsg = { fg = "#000000", bg = "#FFFFFF" },

	Substitute = { fg = "#333333", bg = "#a379f7" },

	Visual = { bg = "#555555" },

	["@keyword"] = { fg = primary },
	["@keyword.return"] = { fg = primary },
	["@keyword.function"] = { fg = primary },
	["@keyword.operator"] = { fg = primary },
	["@type.qualifier"] = { fg = primary },
	["@constructor"] = { fg = primary },
	["@repeat"] = { fg = primary },
	["@conditional"] = { fg = primary },
	["@include"] = { fg = primary },
	["@type.builtin"] = { fg = "#AAAAAA" },
	["@preproc"] = { fg = primary },
	["@comment"] = { fg = "#d68829" },
	["@type.css"] = { fg = primary },
	["@tag"] = { fg = "#AAAAAA" },
	["@constant"] = { fg = secondary },
	["@punctuation"] = { fg = secondary },
	["@function.builtin"] = { fg = secondary },
	["@variable.builtin"] = { fg = "#AAAAAA" },
	["@constant.builtin"] = { fg = "#AAAAAA" },
	["@exception"] = { fg = primary },
}

vim.hl.priorities.semantic_tokens = 95

for k, v in pairs(custom_colors) do
	local k_fg = k.."Fg"
	local k_bg = k.."Bg"

	if v.fg ~= nil then
		Color.new(k_fg, v.fg)
	end
	if v.bg ~= nil then
		Color.new(k_bg, v.bg)
	end
	Group.new(k, colors[k_fg] or colors.none, colors[k_bg] or colors.none)
end
