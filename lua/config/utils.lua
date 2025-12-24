local M = {}

-- io.open("debug.txt", "w"):close()

function M.printFile(...)
	local file = io.open("debug.txt", "a")

	if file == nil then
		return
	end

	local args = {...}

	for _, v in ipairs(args) do
		file:write(vim.inspect(v))
	end

	file:write("\n")

	file:close()
end

function M.ternary(cond, is_true, is_false)
	if cond then
		return is_true
	end
	return is_false
end

function M.visual_select(from, to)
	local diff = from - to
	local motion = "k"

	if diff == 0 then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc><s-v>", true, false, true), 'n', true)
		return
	end

	if diff < 0 then
		vim.cmd(tostring(from))
		motion = "j"
	end

	local seq = "<s-v>"..math.abs(diff)..motion

	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>"..seq, true, false, true), 'n', true)
end

return M
