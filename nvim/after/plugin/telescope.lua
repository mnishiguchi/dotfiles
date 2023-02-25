-- https://github.com/nvim-telescope/telescope.nvim

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>pf', require('telescope.builtin').find_files, { desc = '[P]project [F]iles' })

vim.keymap.set('n', '<leader>ps',
  function()
    require('telescope.builtin').grep_string({ search = vim.fn.input('Grep > ') })
  end,
  { desc = '[P]roject [S]earch' }
)

vim.keymap.set('n', '<C-p>', require('telescope.builtin').git_files, {})

vim.keymap.set('n', '<leader>h', require('telescope.builtin').help_tags, { desc = '[H]elp' })

vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })

vim.keymap.set('n', '<leader>b', require('telescope.builtin').buffers, { desc = 'Find existing [b]uffers' })

vim.keymap.set('n', '<leader>/',
  function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(
      require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      })
    )
  end,
  { desc = '[/] Fuzzily search in current buffer' }
)
