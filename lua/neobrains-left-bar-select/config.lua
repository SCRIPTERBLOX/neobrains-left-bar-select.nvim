local elements = require("neobrains-left-bar-select.elements")

local M = {}

M.default_config = {
  buttons = {
    top = {
      elements.Button
    }
  },
  margin_top = 1,
  width = 3
}

return M
