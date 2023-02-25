-------------------------------------------------------------------------------
-- my neovim settings
-------------------------------------------------------------------------------
print('loading mnishiguchi/init.lua')

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('mnishiguchi/plugin_manager')
require('mnishiguchi/options')
require('mnishiguchi/keymaps')
require('mnishiguchi/autocommands')
