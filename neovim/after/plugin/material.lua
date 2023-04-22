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
