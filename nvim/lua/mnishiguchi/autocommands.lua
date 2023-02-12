-------------------------------------------------------------------------------
-- autocommands
-- see https://neovim.io/doc/user/autocmd.html
-------------------------------------------------------------------------------

local augroup = vim.api.nvim_create_augroup

local random_group = augroup('random', {})

vim.api.nvim_create_autocmd({'BufWritePre'}, {
  group = random_group,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})
