local config = require("neobrains-left-bar-select.config")
local utils = require("neobrains-left-bar-select.utils")

local M = {}

function M.gen_content(user_config, height)
	local content = {}
	local y = 0
	local buttons = user_config.buttons
	
	if buttons.top then
		for _, v in pairs(buttons.top) do
			table.insert(content, "")
			table.insert(content, " " .. v.txt .. " ")
			table.insert(content, "")
		
			y = y + 1
		end
	end


	if buttons.center then
		local center = math.floor(height/2)
		local center_element_rows = (#buttons.center)*3
		local up = math.floor(center_element_rows/2)
		local center_start = center-up
		local rows_til_there = center_start - y

		if rows_til_there > 0 then
			for i = 1, rows_til_there do
				table.insert(content, "")
				y = y + 1
			end
		end

		for _, v in pairs(buttons.center) do
			table.insert(content, "")
			table.insert(content, " " .. v.txt .. " ")
			table.insert(content, "")
			y = y + 1
		end
	end

	return content
end

function M.create(user_config)
	local win_height = vim.api.nvim_win_get_height(0)
	local win_width = vim.api.nvim_win_get_width(0)

	local lines = utils.center_content(M.gen_content(user_config, win_height), win_width, user_config.margin_top)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.cmd("vsplit")
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_win_set_width(0, 3)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "left-bar")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_name(buf, "left-bar")

	return buf
end

return M
