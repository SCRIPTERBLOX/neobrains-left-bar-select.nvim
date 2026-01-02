local config = require("neobrains-left-bar-select.config")
local utils = require("neobrains-left-bar-select.utils")

local buffer = {}

function buffer.gen_content(user_config, height)
	local content = {}
	function content.insert(thing)
		table.insert(content, thing)
	end
	local y = 0

	local buttons = user_config.buttons
	
	if content.top then
		for _, v in pairs(buttons.top) do
			content.insert("")
			content.insert(" " .. v.txt .. " ")
			content.insert("")
		
			y = y + 1
		end
	end


	if content.center then
		local center = math.floor(height/2)
		local center_element_rows = (#buttons.center)*3
		local up = math.floor(center_element_rows/2)
		local center_start = center-up
		local rows_til_there = center_start - y

		if rows_til_there > 0 then
			for i = 1, rows_til_there do
				content.insert("")
				y = y + 1
			end
		end

		for _, v in pairs(buttons.center) do
			content.insert("")
			content.insert(" " .. buttons.txt .. " ")
			content.insert("")
			y = y + 1
		end
	end

	return content
end

function buffer.create(user_config)
	local win_height = vim.api.nvim_win_get_height(0)
	local win_width = vim.api.nvim_win_get_width(0)

	local lines = utils.center_content(buffer.gen_content(user_config, win_height), win_width, config.margin_top)

	local buf = vim.api.nvim_create_buf()
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "left-bar")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_name(buf, "left-bar")

	return buf, lines
end

return buffer
