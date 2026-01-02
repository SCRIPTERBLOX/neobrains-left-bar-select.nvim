local M

function M.create(user_config)
	local cfg = vim.tbl_deep_extend("force", require("neobrains-left-bar-select.config").default_config, user_config or {})
end

return M
