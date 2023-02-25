-------------------------------------------------------------------------------
-- plugins that I use
-------------------------------------------------------------------------------

-- Install package manager
-- * https://github.com/folke/lazy.nvim
-- * See `:help lazy.nvim.txt`
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
  -- NOTE: First, some plugins that don't require any configuration

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
  -- * See `:help unimpaired.txt`
  'tpope/vim-unimpaired',

  -- Use CTRL-A/CTRL-X to increment dates, times, and more
  'tpope/vim-speeddating',

  -- Enable repeating supported plugin maps with `.`
  'tpope/vim-repeat',

  -- Show pending keybinds
  'folke/which-key.nvim',

  -- https://github.com/VonHeikemen/lsp-zero.nvim
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
    config = function()
      local lsp = require('lsp-zero').preset({
        name = 'minimal',
        set_lsp_keymaps = true,
        manage_nvim_cmp = true,
        suggest_lsp_servers = false,
      })

      -- (Optional) Configure lua language server for neovim
      lsp.nvim_workspace()

      lsp.setup()
    end
  },

  -- Adds git releated signs to the gutter, as well as utilities for managing changes
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },

  -- Theme
  {
    'marko-cerovac/material.nvim',
    priority = 1000,
    config = function()
      vim.g.material_style = 'deep ocean'

      require('material').setup({
        -- Uncomment the plugins that you use to highlight them
        plugins = {
          -- Available plugins:
          -- 'dap',
          -- 'dashboard',
          'gitsigns',
          -- 'hop',
          'indent-blankline',
          -- 'lspsaga',
          -- 'mini',
          -- 'neogit',
          'nvim-cmp',
          -- 'nvim-navic',
          -- 'nvim-tree',
          -- 'nvim-web-devicons',
          -- 'sneak',
          'telescope',
          -- 'trouble',
          'which-key',
        }
      })

      -- Enable the colorscheme after the setup function call
      vim.cmd.colorscheme('material')
    end,
  },

  -- Set lualine as statusline
  {
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        globalstatus = true,
        icons_enabled = false,
        theme = 'material',
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
    },
  },

  -- Add indentation guides on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    -- See `:help indent_blankline.txt`
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = { 'nvim-lua/plenary.nvim' },
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
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
      pcall(
        require('nvim-treesitter.install').update({
          with_sync = true
        })
      )

      require('nvim-treesitter.configs').setup({
        -- A list of parsers that should always be installed
        ensure_installed = {
          'c',
          'elixir',
          'erlang',
          'help',
          'javascript',
          'lua',
          'ruby',
          'typescript',
          'vim',
        },
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
  },

  -- Toggle a terminal
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require('toggleterm').setup({
        open_mapping = [[<c-\>]],
        size = 80,
        direction = 'vertical'
      })
    end,
  },

  -- Highlight, list and search todo comments
  {
    'folke/todo-comments.nvim',
    config = function()
      require('todo-comments').setup()
    end
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

}, {})

