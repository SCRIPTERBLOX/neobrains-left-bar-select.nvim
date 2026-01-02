local M

function M.init(user_config)
	local cfg = vim.tbl_deep_extend("force", require("neobrains-left-bar-select.config").default_config, user_config or {})

	print(cfg)

	--local buf, lines = buffer;

	--return buf
end

return M
