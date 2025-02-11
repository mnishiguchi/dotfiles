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
  "cohama/lexima.vim",                                 -- Add end after if, do, def etc
  "tpope/vim-abolish",                                 -- Convert text case under the cursor with crp, crs, cru etc
  "tpope/vim-commentary",                              -- Comment out the target of a motion with gc
  "tpope/vim-eunuch",                                  -- File utilities, like Delete, Move, Rename, Copy, Duplicate, etc
  "tpope/vim-rhubarb",                                 -- GBrowse
  "vim-scripts/ReplaceWithRegister",                   -- Replace text with the contents of a register with [count]["x]gr{motion}
  require("mnishiguchi.plugins.alpha"),                -- Start screen
  require("mnishiguchi.plugins.formatter"),            -- Format code with external commands
  require("mnishiguchi.plugins.fugitive"),             -- Git
  require("mnishiguchi.plugins.git-blame"),            -- Git Blame
  require("mnishiguchi.plugins.gitsigns"),             -- Adds git releated signs to the gutter, as well as utilities for managing changes
  require("mnishiguchi.plugins.harpoon"),              -- Manage project marks
  require("mnishiguchi.plugins.indent-blankline"),     -- Add indentation guides on blank lines
  require("mnishiguchi.plugins.lsp-zero"),             -- A starting point to setup some LSP related features
  require("mnishiguchi.plugins.lualine"),              -- Set lualine as statusline
  require("mnishiguchi.plugins.nvim-surround"),        -- surroundings with ys{motion}{char}, ds{char}, and cs{target}{replacement}
  require("mnishiguchi.plugins.nvim-treesitter"),      -- Highlight, edit, and navigate code
  require("mnishiguchi.plugins.project"),              -- Automagically cd to project directory
  require("mnishiguchi.plugins.telescope"),            -- Fuzzy Finder (files, lsp, etc)
  require("mnishiguchi.plugins.todo-comments"),        -- Highlight, list and search todo comments
  require("mnishiguchi.plugins.undotree"),             -- Visualize the undo history
  require("mnishiguchi.plugins.vimwiki"),
  require("mnishiguchi.plugins.which-key"),            -- Show pending keybinds
}

M.setup = function()
  install_plugin_manager()
  require("lazy").setup(plugins)
end

return M
