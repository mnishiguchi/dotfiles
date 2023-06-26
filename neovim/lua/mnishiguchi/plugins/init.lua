local M = {}

-- Install package manager and plugins
-- * Plugins can be configured here, or anytime after the setup call
-- * https://github.com/folke/lazy.nvim
local install_plugin_manager = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end

  vim.opt.rtp:prepend(lazypath)
end

local plugins = {
  require("mnishiguchi.plugins.colorscheme"),
  "tpope/vim-fugitive",                               -- Git
  "tpope/vim-rhubarb",                                -- GBrowse
  "tpope/vim-eunuch",                                 -- File utilities, like Delete, Move, Rename, Copy, Duplicate, etc
  "tpope/vim-commentary",                             -- Comment out the target of a motion with gc
  "tpope/vim-unimpaired",                             -- Pairs of handy bracket mappings
  "tpope/vim-repeat",                                 -- Enable repeating supported plugin maps with `.`
  "tpope/vim-abolish",                                -- Convert text case under the cursor with crp, crs, cru etc
  "mbbill/undotree",                                  -- Visualize the undo history
  "vim-scripts/ReplaceWithRegister",                  -- Replace text with the contents of a register with [count]["x]gr{motion}
  "mg979/vim-visual-multi",                           -- Multiple cursors with Ctrl-n and Ctrl-Up/Down
  "mhinz/vim-startify",                               -- Start screen
  require("mnishiguchi.plugins.lualine"),             -- Set lualine as statusline
  require("mnishiguchi.plugins.gitsigns"),            -- Adds git releated signs to the gutter, as well as utilities for managing changes
  require("mnishiguchi.plugins.toggleterm"),          -- Toggle a terminal
  require("mnishiguchi.plugins.nvim-surround"),       -- surroundings with ys{motion}{char}, ds{char}, and cs{target}{replacement}
  require("mnishiguchi.plugins.harpoon"),             -- Manage project marks
  require("mnishiguchi.plugins.indent-blankline"),    -- Add indentation guides on blank lines
  require("mnishiguchi.plugins.lsp-zero"),            -- A starting point to setup some LSP related features
  require("mnishiguchi.plugins.telescope"),           -- Fuzzy Finder (files, lsp, etc)
  require("mnishiguchi.plugins.telescope-fzf-native"), -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  require("mnishiguchi.plugins.nvim-treesitter"),     -- Highlight, edit, and navigate code
  require("mnishiguchi.plugins.which-key"),           -- Show pending keybinds
  require("mnishiguchi.plugins.todo-comments"),       -- Highlight, list and search todo comments
  require("mnishiguchi.plugins.null-ls"),             -- Inject LSP diagnostics, code actions, and more
}

M.setup = function()
  install_plugin_manager()
  require("lazy").setup(plugins)
end

return M
