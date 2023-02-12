-- https://github.com/marko-cerovac/material.nvim
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
      'neogit',
      'nvim-cmp',
      -- 'nvim-navic',
      -- 'nvim-tree',
      -- 'nvim-web-devicons',
      -- 'sneak',
      'telescope',
      -- 'trouble',
      -- 'which-key',
  }
})

-- make sure to enable the colorscheme after the setup function call
vim.cmd.colorscheme('material')

-- https://github.com/ThePrimeagen/init.lua/blob/249f3b14cc517202c80c6babd0f9ec548351ec71/after/plugin/colors.lua
function changeStyle()
  require('material.functions').find_style()
end
