-- https://github.com/ThePrimeagen/harpoon
local mark = require('harpoon.mark')
local ui = require('harpoon.ui')

-- mark a file that I want to revisit later on
vim.keymap.set('n', '<leader>a', mark.add_file, {desc = '[a]dd file to the project harpoon marks'})

-- view all project marks
vim.keymap.set('n', '<C-e>', ui.toggle_quick_menu, {desc = 'list the project harpoon marks'})

-- revisit a marked project file
vim.keymap.set('n', '<C-h>', function() ui.nav_file(1) end, {desc = 'jump to 1st harpoon mark'})
vim.keymap.set('n', '<C-t>', function() ui.nav_file(2) end, {desc = 'jump to 2nd harpoon mark'})
vim.keymap.set('n', '<C-n>', function() ui.nav_file(3) end, {desc = 'jump to 3rd harpoon mark'})
