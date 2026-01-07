local config = require("neobrains-left-bar-select.config")
local utils = require("neobrains-left-bar-select.utils")

local M = {}

function M.gen_content(user_config, height)
	local content = {}
	local button_map = {}
	local y = 0
	local buttons = user_config.buttons
	
	if buttons.top then
		for _, v in pairs(buttons.top) do
			table.insert(content, "╭" .."───".. "╮")
			table.insert(content, "⎪ "..v.txt.." ⎪")
			table.insert(content, "╰" .."───".. "╯")
			
			-- Map button to its lines (button spans 3 lines: top, middle, bottom)
			local start_line = #content - 2
			button_map[start_line + 1] = v  -- Middle line (1-based)
			button_map[start_line + 2] = v  -- Bottom line
			button_map[start_line] = v      -- Top line
			
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
			table.insert(content, "╭" .."───".. "╮")
			table.insert(content, "⎪ "..v.txt.." ⎪")
			table.insert(content, "╰" .."───".. "╯")
			
			-- Map button to its lines (button spans 3 lines: top, middle, bottom)
			local start_line = #content - 2
			button_map[start_line + 1] = v  -- Middle line (1-based)
			button_map[start_line + 2] = v  -- Bottom line
			button_map[start_line] = v      -- Top line
			
			y = y + 1
		end
	end

	return content, button_map
end

function M.create(user_config)
	local win_height = vim.api.nvim_win_get_height(0)
	local win_width = vim.api.nvim_win_get_width(0)

	local lines, button_map = M.gen_content(user_config, win_height)--utils.center_content(M.gen_content(user_config, win_height), win_width, user_config.margin_top)

	local buf = vim.api.nvim_create_buf(false, true)
	vim.cmd("vsplit")
	local win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_option(win, "winfixwidth", true)
	vim.api.nvim_win_set_option(win, "winfixheight", true)
	vim.api.nvim_win_set_buf(win, buf)
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_win_set_width(win, 5)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "left-bar")
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_name(buf, "left-bar")

	-- Setup button action handlers (will handle modifiable state internally)
	M.setup_actions(buf, win, button_map)

	return buf
end

function M.setup_actions(buf, win, button_map)
	-- Make buffer temporarily modifiable to set keymaps
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	
	-- Handle Enter key press
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "", {
		callback = function()
			local cursor_line = vim.api.nvim_win_get_cursor(win)[1]
			local button = button_map[cursor_line]
			if button and button.action then
				button.action()
			end
		end,
		desc = "Execute button action"
	})

	-- Handle mouse clicks in the button window
	vim.api.nvim_buf_set_keymap(buf, "n", "<LeftMouse>", "", {
		callback = function()
			local mouse_pos = vim.fn.getmousepos()
			local button = button_map[mouse_pos.line]
			if button and button.action then
				button.action()
				vim.cmd("wincmd l")
				return -- Don't process normal mouse behavior
			end
		end,
		desc = "Execute button action on click"
	})
	
	-- Make buffer non-modifiable again
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

return M
