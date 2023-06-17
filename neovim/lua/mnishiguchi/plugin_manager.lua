-------------------------------------------------------------------------------
-- plugins that I use
-------------------------------------------------------------------------------

-- Install package manager https://github.com/folke/lazy.nvim
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
-- * https://github.com/folke/lazy.nvim
require('lazy').setup({
  -- colorscheme
  {
    'marko-cerovac/material.nvim',
    lazy = false, -- load this during startup
    priority = 1000, -- load this before all the other start plugins
    config = function()
      vim.g.material_style = 'deep ocean'

      require('material').setup({
        -- plugins that you use to highlight them
        plugins = {'gitsigns', 'indent-blankline', 'nvim-cmp', 'telescope', 'which-key'}
      })

      -- Enable the colorscheme after the setup function call
      vim.cmd.colorscheme('material')
    end
  },

  -- Git related plugins
  'tpope/vim-fugitive',
  -- GBrowse
  'tpope/vim-rhubarb',
  -- File utilities, like Delete, Move, Rename, Copy, Duplicate, etc
  'tpope/vim-eunuch',
  -- Comment out the target of a motion with gc
  'tpope/vim-commentary',
  -- Delete, change and add surroundings with ds, cs and ys
  'tpope/vim-surround',
  -- Pairs of handy bracket mappings
  'tpope/vim-unimpaired',
  -- Enable repeating supported plugin maps with `.`
  'tpope/vim-repeat',
  -- Convert text case under the cursor with crp, crs, cru etc
  'tpope/vim-abolish',
  -- Visualize the undo history
  'mbbill/undotree',
  -- Replace text with the contents of a register with [count]["x]gr{motion}
  'vim-scripts/ReplaceWithRegister',
  -- Multiple cursors with Ctrl-n and Ctrl-Up/Down
  'mg979/vim-visual-multi',

  -- Set lualine as statusline
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        globalstatus = true,
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
          {
            'filename',
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1 -- 0 = just filename, 1 = relative path, 2 = absolute path
          }
        },
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      }
    }
  },

  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
  },

  -- Toggle a terminal
  {
    'akinsho/toggleterm.nvim',
    opts = {
      open_mapping = [[<c-\>]],
      size = 80,
      direction = 'vertical'
    }
  },

  -- Manage project marks
  {
    'ThePrimeagen/harpoon',
    opts = {
      menu = {
        width = vim.api.nvim_win_get_width(0) - 4,
      }
    }
  },

  -- Add indentation guides on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    }
  },

  -- A starting point to setup some LSP related features
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    config = function()
      local lsp = require('lsp-zero').preset({})

      -- https://github.com/williamboman/mason-lspconfig.nvim
      lsp.ensure_installed({'elixirls', 'lua_ls', 'solargraph'})

      lsp.setup()
    end,
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason-lspconfig.nvim'}, -- Optional
      {                                      -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },

      -- Autocompletion
      'hrsh7th/nvim-cmp',     -- Required
      'hrsh7th/cmp-nvim-lsp', -- Required
      {                       -- Required
        "L3MON4D3/LuaSnip",
        dependencies = {
          {
            -- https://github.com/rafamadriz/friendly-snippets
            'rafamadriz/friendly-snippets',
            init = function()
              require("luasnip.loaders.from_vscode").lazy_load()
            end,
          },
        },
      },
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = {
              ['<C-u>'] = false,
              ['<C-d>'] = false,
            },
          },
        },
      }

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
    end,
    dependencies = {'nvim-lua/plenary.nvim'}
  },

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
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      pcall(require('nvim-treesitter.install').update({ with_sync = true }))

      require('nvim-treesitter.configs').setup({
        -- A list of parsers that should always be installed
        ensure_installed = {'c', 'elixir', 'help', 'javascript', 'lua', 'ruby', 'vim'},
        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- Automatically install missing parsers when entering buffer
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end,
    dependencies = {'nvim-treesitter/nvim-treesitter-textobjects'}
  },

  -- Highlight, list and search todo comments
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end,
    dependencies = {'nvim-lua/plenary.nvim'}
  },

  -- Show pending keybinds
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

}, {})

