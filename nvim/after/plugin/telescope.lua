local builtin = require('telescope.builtin')

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
  builtin.find_files,
  { desc = '[p]roject [f]iles' }
)

vim.keymap.set('n', '<leader>ps',
  function()
    builtin.grep_string({ search = vim.fn.input('Grep > ') })
  end,
  { desc = '[p]roject [s]earch' }
)

vim.keymap.set('n', '<C-p>',
  builtin.git_files,
  { desc = '[p]roject git files' }
)

vim.keymap.set('n', '<leader>h',
  builtin.help_tags,
  { desc = '[h]elp' }
)

vim.keymap.set('n', '<leader>?',
  builtin.oldfiles,
  { desc = '[?] find recently opened files' }
)

vim.keymap.set('n', '<leader>b',
  builtin.buffers,
  { desc = 'find existing [b]uffers' }
)

vim.keymap.set('n', '<leader>gb',
  builtin.git_branches,
  { desc = 'list all [g]it [b]ranches' }
)

vim.keymap.set('n', '<leader>gc',
  builtin.git_commits,
  { desc = 'list all [g]it [c]ommits' }
)

vim.keymap.set('n', '<leader>/',
  function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(
      require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
      })
    )
  end,
  { desc = '[/] fuzzily search in current buffer' }
)
