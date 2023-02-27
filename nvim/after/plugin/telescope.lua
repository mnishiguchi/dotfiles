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

vim.keymap.set('n', '<leader>pf',
  require('telescope.builtin').find_files,
  { desc = '[p]roject [f]iles' }
)

vim.keymap.set('n', '<leader>ps',
  function()
    require('telescope.builtin').grep_string({ search = vim.fn.input('Grep > ') })
  end,
  { desc = '[p]roject [s]earch' }
)

vim.keymap.set('n', '<C-p>',
  require('telescope.builtin').git_files,
  { desc = '[p]roject git files' }
)

vim.keymap.set('n', '<leader>h',
  require('telescope.builtin').help_tags,
  { desc = '[h]elp' }
)

vim.keymap.set('n', '<leader>?',
  require('telescope.builtin').oldfiles,
  { desc = '[?] find recently opened files' }
)

vim.keymap.set('n', '<leader>b',
  require('telescope.builtin').buffers,
  { desc = 'find existing [b]uffers' }
)

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
  { desc = '[/] fuzzily search in current buffer' }
)
