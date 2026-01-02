local buffer = require("neobrains-left-bar-select.buffer")

local M = {}

function M.init(user_config)
	local cfg = vim.tbl_deep_extend("force", require("neobrains-left-bar-select.config").default_config, user_config or {})

	local buf, lines = buffer.create(cfg)

	autocmds.setup_auto_recreate(buf, lines, cfg)

	return buf
end

return M
