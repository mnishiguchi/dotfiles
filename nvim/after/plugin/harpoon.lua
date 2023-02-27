require('harpoon').setup({
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  }
})

-- https://github.com/ThePrimeagen/harpoon
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

-- mark a file that I want to revisit later on
vim.keymap.set('n', '<leader>a', mark.add_file)

-- view all project marks
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu)

-- revisit a marked project file
vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end)
vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end)
vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end)
