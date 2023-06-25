print("loading mnishiguchi/init.lua")

require("mnishiguchi.options")
require("mnishiguchi.keymaps")
require("mnishiguchi.autocmds")

local plugin_manager = require("mnishiguchi.plugins")
plugin_manager.setup()
