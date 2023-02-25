-------------------------------------------------------------------------------
-- autocommands
-- see https://neovim.io/doc/user/autocmd.html
-------------------------------------------------------------------------------

local random_group = vim.api.nvim_create_augroup('random', {})

-- Strip trailing whitespace on write
vim.api.nvim_create_autocmd('BufWritePre', {
  group = random_group,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = random_group,
  pattern = '*',
  callback = function()
    -- See `:help vim.highlight.on_yank()`
    vim.highlight.on_yank()
  end,
})
