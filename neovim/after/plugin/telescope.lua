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

vim.keymap.set('n', '<leader>km', builtin.keymaps, { desc = '[k]ey[m]aps' })
vim.keymap.set('n', '<leader>ps', builtin.live_grep, { desc = '[p]roject [s]earch' })
vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '[p]roject: [f]iles' })
vim.keymap.set('n', '<leader>pg', builtin.git_files, { desc = '[p]roject: [g]it files' })
vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = '[p]roject: git files' })
vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = '[h]elp' })
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[b]uffers' })
vim.keymap.set('n', '<leader>m', builtin.marks, { desc = '[m]arks' })
vim.keymap.set('n', '<leader>r', builtin.registers, { desc = '[r]egisters' })
vim.keymap.set('n', '<leader>t', builtin.tags, { desc = '[t]ags' })
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = '[g]it [b]ranches' })
vim.keymap.set('n', '<leader>gl', builtin.git_bcommits, { desc = '[g]it commit [l]og of the current buffer' })
vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] recently opened files' })
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
