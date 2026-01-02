local elements = require("neobrains-left-bar-select.elements")

local config = {}

config.default_config = {
  buttons = {
    top = {
      elements.Button,
      elements.Button,
      elements.Spacer
    }
  },
  margin_top = 1,
  width = 3
}

return config
