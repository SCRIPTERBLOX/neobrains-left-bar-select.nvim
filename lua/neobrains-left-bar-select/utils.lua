local utils = {}

function utils.center_content(content, win_width, win_height)
	local lines = {}
	local padding = math.floor((win_height - #content) / 2)

	for i = 1, padding do
		table.insert(lines, "")
	end

	for _, line in ipairs(content) do
		local padding = math.floor((win_width - #line) / 2)
		local centered_line = string.rep(" ", padding) .. line
		table.insert(lines, centered_line)
	end

	return lines

return utils
