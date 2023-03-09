-------------------------------------------------------------------------------
-- plugins that I use
-------------------------------------------------------------------------------

-- Install package manager
-- * https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
-- * Plugins can be configured here, or anytime after the setup call
require('lazy').setup({
  -- colorscheme
  {
    'marko-cerovac/material.nvim',
    lazy = false, -- load this during startup
    priority = 1000, -- load this before all the other start plugins
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',
  -- Vim sugar for the UNIX shell commands
  'tpope/vim-eunuch',
  -- Comment out the target of a motion with gc
  'tpope/vim-commentary',
  -- Delete, change and add surroundings with ds, cs and ys
  'tpope/vim-surround',
  -- Pairs of handy bracket mappings
  'tpope/vim-unimpaired',
  -- Use CTRL-A/CTRL-X to increment dates, times, and more
  'tpope/vim-speeddating',
  -- Enable repeating supported plugin maps with `.`
  'tpope/vim-repeat',
  -- Show pending keybinds
  'folke/which-key.nvim',
  -- Visualize the undo history
  'mbbill/undotree',
  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  -- Set lualine as statusline
  'nvim-lualine/lualine.nvim',
  -- Add indentation guides on blank lines
  'lukas-reineke/indent-blankline.nvim',
  -- Manage project marks
  'ThePrimeagen/harpoon',
  -- Toggle a terminal
  'akinsho/toggleterm.nvim',
  -- Automatically save changes
  'pocco81/auto-save.nvim',

  -- A starting point to setup some LSP related features
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v1.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},         -- Required
      {'hrsh7th/cmp-nvim-lsp'},     -- Required
      {'hrsh7th/cmp-buffer'},       -- Optional
      {'hrsh7th/cmp-path'},         -- Optional
      {'saadparwaiz1/cmp_luasnip'}, -- Optional
      {'hrsh7th/cmp-nvim-lua'},     -- Optional

      -- Snippets
      {'L3MON4D3/LuaSnip'},             -- Required
      {'rafamadriz/friendly-snippets'}, -- Optional
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {'nvim-telescope/telescope.nvim', dependencies = {'nvim-lua/plenary.nvim'}},

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  -- Highlight, edit, and navigate code
  {'nvim-treesitter/nvim-treesitter', dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'}},

  -- Highlight, list and search todo comments
  {'folke/todo-comments.nvim', dependencies = {'nvim-lua/plenary.nvim'}},

}, {})

